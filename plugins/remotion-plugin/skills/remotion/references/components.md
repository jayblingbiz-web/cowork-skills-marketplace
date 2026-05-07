# Remotion Components Reference

## Table of Contents
- [Composition](#composition)
- [Sequence](#sequence)
- [Series](#series)
- [TransitionSeries](#transitionseries)
- [AbsoluteFill](#absolutefill)
- [Media Components](#media-components)

---

## Composition

Defines a renderable video with metadata. Register in `src/Root.tsx`:

```tsx
import { Composition } from 'remotion';

<Composition
  id="MyVideo"              // Unique identifier for rendering
  component={MyComponent}   // React component to render
  durationInFrames={150}    // Total frames
  fps={30}                  // Frames per second
  width={1920}              // Width in pixels
  height={1080}             // Height in pixels
  defaultProps={{ text: 'Hello' }}  // Optional default props
/>
```

**Multiple compositions** in one project:
```tsx
export const RemotionRoot: React.FC = () => (
  <>
    <Composition id="Intro" component={Intro} ... />
    <Composition id="MainVideo" component={MainVideo} ... />
    <Composition id="Outro" component={Outro} ... />
  </>
);
```

---

## Sequence

Time-shifts children to appear at a specific frame. Children's `useCurrentFrame()` resets to 0.

```tsx
import { Sequence } from 'remotion';

// Basic usage - appears at frame 30
<Sequence from={30}>
  <MyComponent />
</Sequence>

// With duration - unmounts after 60 frames
<Sequence from={30} durationInFrames={60}>
  <MyComponent />
</Sequence>

// Named sequence (shows in timeline)
<Sequence from={0} name="Title Card">
  <TitleCard />
</Sequence>

// Without AbsoluteFill wrapper
<Sequence from={30} layout="none">
  <InlineElement />
</Sequence>
```

**Nested sequences cascade**:
```tsx
<Sequence from={30}>
  <Sequence from={15}>  {/* Actually starts at frame 45 */}
    <Component />
  </Sequence>
</Sequence>
```

---

## Series

Plays sequences back-to-back automatically:

```tsx
import { Series } from 'remotion';

<Series>
  <Series.Sequence durationInFrames={30}>
    <Scene1 />  {/* Frames 0-29 */}
  </Series.Sequence>
  <Series.Sequence durationInFrames={45}>
    <Scene2 />  {/* Frames 30-74 */}
  </Series.Sequence>
  <Series.Sequence durationInFrames={30}>
    <Scene3 />  {/* Frames 75-104 */}
  </Series.Sequence>
</Series>

// With offset (gap or overlap)
<Series>
  <Series.Sequence durationInFrames={30}>
    <Scene1 />
  </Series.Sequence>
  <Series.Sequence offset={-5} durationInFrames={30}>
    <Scene2 />  {/* Starts 5 frames earlier, overlapping */}
  </Series.Sequence>
</Series>
```

---

## TransitionSeries

Like Series but with transitions between sequences:

```tsx
import { TransitionSeries, linearTiming } from '@remotion/transitions';
import { fade } from '@remotion/transitions/fade';
import { slide } from '@remotion/transitions/slide';

<TransitionSeries>
  <TransitionSeries.Sequence durationInFrames={60}>
    <Scene1 />
  </TransitionSeries.Sequence>

  <TransitionSeries.Transition
    presentation={fade()}
    timing={linearTiming({ durationInFrames: 15 })}
  />

  <TransitionSeries.Sequence durationInFrames={60}>
    <Scene2 />
  </TransitionSeries.Sequence>

  <TransitionSeries.Transition
    presentation={slide({ direction: 'from-left' })}
    timing={linearTiming({ durationInFrames: 20 })}
  />

  <TransitionSeries.Sequence durationInFrames={60}>
    <Scene3 />
  </TransitionSeries.Sequence>
</TransitionSeries>
```

**Built-in transitions** (from `@remotion/transitions`):
- `fade()` - Crossfade
- `slide({ direction })` - Slide in/out ('from-left', 'from-right', 'from-top', 'from-bottom')
- `wipe({ direction })` - Wipe transition
- `flip({ direction })` - 3D flip

---

## AbsoluteFill

Full-frame container for layering. Renders as `position: absolute` filling the composition.

```tsx
import { AbsoluteFill } from 'remotion';

// Layered composition (last child renders on top)
<AbsoluteFill style={{ backgroundColor: '#000' }}>
  <AbsoluteFill>
    <Background />
  </AbsoluteFill>
  <AbsoluteFill>
    <MainContent />
  </AbsoluteFill>
  <AbsoluteFill style={{ pointerEvents: 'none' }}>
    <Overlay />
  </AbsoluteFill>
</AbsoluteFill>
```

---

## Media Components

### Img
Renders image and waits for load:
```tsx
import { Img, staticFile } from 'remotion';

<Img src={staticFile('logo.png')} style={{ width: 200 }} />
<Img src="https://example.com/image.jpg" />
```

### Video
Embeds video with frame-sync:
```tsx
import { Video, staticFile } from 'remotion';

<Video
  src={staticFile('clip.mp4')}
  volume={0.5}                    // 0 to 1
  playbackRate={1}                // Speed multiplier
  startFrom={30}                  // Skip first 30 frames of source
  endAt={150}                     // End at frame 150 of source
/>

// Muted video
<Video src={staticFile('clip.mp4')} muted />
```

### Audio
Adds audio track:
```tsx
import { Audio, staticFile } from 'remotion';

<Audio
  src={staticFile('music.mp3')}
  volume={0.8}
  startFrom={0}                   // Start from beginning
/>

// Dynamic volume (fade in)
<Audio
  src={staticFile('music.mp3')}
  volume={(f) => Math.min(1, f / 30)}  // Fade in over 30 frames
/>
```

### Gif
Animated GIFs (requires `@remotion/gif`):
```tsx
import { Gif } from '@remotion/gif';
import { staticFile } from 'remotion';

<Gif
  src={staticFile('animation.gif')}
  width={200}
  height={200}
  fit="contain"  // 'contain', 'cover', 'fill'
/>
```

### OffthreadVideo
For better performance with many videos:
```tsx
import { OffthreadVideo, staticFile } from 'remotion';

<OffthreadVideo src={staticFile('heavy-video.mp4')} />
```
