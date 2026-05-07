---
name: remotion
description: "Create videos programmatically using React and Remotion. Supports animations, compositions, sequences, and rendering to MP4/WebM. Use when users want to create video animations with code, build React-based video compositions, generate videos programmatically, make text animations, logo reveals, slideshows, music visualizers, motion graphics, or render videos from React components."
---

# Remotion

Create videos programmatically using React. Remotion treats video as a function of time—write React components that receive a frame number and render accordingly.

## Quick Start Workflow

1. **Initialize** a new project with `scripts/init_remotion.sh`
2. **Develop** compositions in `src/` using React + Remotion APIs
3. **Preview** with `npm start` (opens Remotion Studio at localhost:3000)
4. **Render** with `npx remotion render <composition-id> out.mp4`

## Core Concepts

Every Remotion video requires:
- **width/height**: Dimensions in pixels (default: 1920x1080)
- **fps**: Frames per second (default: 30)
- **durationInFrames**: Total frames (duration = durationInFrames / fps)

```tsx
// src/Root.tsx - Register compositions here
import { Composition } from 'remotion';
import { MyVideo } from './MyVideo';

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="MyVideo"
      component={MyVideo}
      durationInFrames={150}  // 5 seconds at 30fps
      fps={30}
      width={1920}
      height={1080}
    />
  );
};
```

## Essential APIs

### useCurrentFrame()
Returns the current frame number (0-indexed):
```tsx
const frame = useCurrentFrame(); // 0, 1, 2, ... durationInFrames-1
```

### useVideoConfig()
Returns composition metadata:
```tsx
const { fps, durationInFrames, width, height } = useVideoConfig();
```

### interpolate()
Map frame ranges to value ranges:
```tsx
import { interpolate } from 'remotion';

// Fade in from frame 0-30
const opacity = interpolate(frame, [0, 30], [0, 1], {
  extrapolateRight: 'clamp',
});

// Move from x=0 to x=200 between frames 10-40
const translateX = interpolate(frame, [10, 40], [0, 200], {
  extrapolateLeft: 'clamp',
  extrapolateRight: 'clamp',
});
```

### spring()
Physics-based animations:
```tsx
import { spring } from 'remotion';

const scale = spring({
  frame,
  fps,
  config: { damping: 10, stiffness: 100, mass: 1 },
});
```

## Components Quick Reference

### Sequence - Time-shift children
```tsx
import { Sequence } from 'remotion';

<Sequence from={30} durationInFrames={60}>
  <MyComponent />  {/* Appears at frame 30, lasts 60 frames */}
</Sequence>
```

### AbsoluteFill - Full-frame layering
```tsx
import { AbsoluteFill } from 'remotion';

<AbsoluteFill style={{ backgroundColor: 'white' }}>
  <AbsoluteFill style={{ opacity: 0.5 }}>
    <Overlay />  {/* Layers stack, last renders on top */}
  </AbsoluteFill>
</AbsoluteFill>
```

### Media Components
```tsx
import { Video, Audio, Img } from 'remotion';
import { Gif } from '@remotion/gif';

<Img src={staticFile('logo.png')} />
<Video src={staticFile('clip.mp4')} volume={0.5} />
<Audio src={staticFile('music.mp3')} volume={0.8} />
```

## Common Animation Patterns

### Fade In/Out
```tsx
export const FadeIn: React.FC = () => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: 'clamp',
  });
  return <div style={{ opacity }}>Hello World</div>;
};
```

### Slide In from Left
```tsx
export const SlideIn: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const translateX = spring({
    frame,
    fps,
    config: { damping: 12, stiffness: 100 },
  });

  return (
    <div style={{ transform: `translateX(${interpolate(translateX, [0, 1], [-100, 0])}%)` }}>
      Sliding Text
    </div>
  );
};
```

### Scale Pop-In
```tsx
export const PopIn: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const scale = spring({
    frame,
    fps,
    config: { damping: 8, stiffness: 200 },
  });

  return (
    <div style={{ transform: `scale(${scale})` }}>
      Pop!
    </div>
  );
};
```

### Staggered Elements
```tsx
export const Staggered: React.FC = () => {
  const items = ['First', 'Second', 'Third'];

  return (
    <>
      {items.map((item, i) => (
        <Sequence key={item} from={i * 15} durationInFrames={90}>
          <FadeIn>{item}</FadeIn>
        </Sequence>
      ))}
    </>
  );
};
```

## Rendering

Basic render to MP4:
```bash
npx remotion render src/index.ts MyVideo out/video.mp4
```

Common options:
```bash
npx remotion render MyVideo out.mp4 --codec=h264 --crf=18
npx remotion render MyVideo out.webm --codec=vp9
npx remotion render MyVideo --frames=0-59  # First 2 seconds at 30fps
```

## Important Rules

1. **No Math.random()** - Use Remotion's `random()` for deterministic results:
   ```tsx
   import { random } from 'remotion';
   const value = random('my-seed'); // Same value every render
   ```

2. **Use staticFile() for assets** - Never use relative paths:
   ```tsx
   import { staticFile } from 'remotion';
   <Img src={staticFile('logo.png')} />  // from public/ folder
   ```

3. **Frames start at 0** - Last frame is `durationInFrames - 1`

4. **Always clamp interpolations** to prevent values outside expected range

## Resources

- **Component details**: See [references/components.md](references/components.md) for Sequence, Series, TransitionSeries, and media components
- **Animation techniques**: See [references/animations.md](references/animations.md) for interpolate options, spring configs, and easing
- **Rendering options**: See [references/rendering.md](references/rendering.md) for codecs, quality settings, and Lambda deployment

## Project Initialization

Run the init script to create a new Remotion project:
```bash
bash scripts/init_remotion.sh my-video-project
cd my-video-project
npm start
```
