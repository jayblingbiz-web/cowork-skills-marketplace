# Remotion Animations Reference

## Table of Contents
- [interpolate()](#interpolate)
- [spring()](#spring)
- [Easing Functions](#easing-functions)
- [interpolateColors()](#interpolatecolors)
- [Animation Patterns](#animation-patterns)

---

## interpolate()

Maps input range to output range. Core animation function.

```tsx
import { interpolate } from 'remotion';

interpolate(
  value,           // Current value (usually frame)
  inputRange,      // [start, end] or [a, b, c, ...]
  outputRange,     // [start, end] or [a, b, c, ...]
  options?         // Configuration object
);
```

### Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `extrapolateLeft` | `'extend'`, `'clamp'`, `'identity'` | `'extend'` | Behavior before input range |
| `extrapolateRight` | `'extend'`, `'clamp'`, `'identity'` | `'extend'` | Behavior after input range |
| `easing` | Easing function | linear | Animation curve |

### Examples

```tsx
// Fade in (frames 0-30)
const opacity = interpolate(frame, [0, 30], [0, 1], {
  extrapolateRight: 'clamp',
});

// Move X (frames 10-50)
const x = interpolate(frame, [10, 50], [0, 500], {
  extrapolateLeft: 'clamp',
  extrapolateRight: 'clamp',
});

// Multi-point: fade in, hold, fade out
const opacity = interpolate(
  frame,
  [0, 20, 80, 100],  // Input keyframes
  [0, 1, 1, 0],       // Output values
  { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
);

// With easing
import { Easing } from 'remotion';
const y = interpolate(frame, [0, 60], [0, 300], {
  easing: Easing.bezier(0.25, 0.1, 0.25, 1),
});
```

---

## spring()

Physics-based animations with natural motion.

```tsx
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';

const { fps } = useVideoConfig();
const frame = useCurrentFrame();

const value = spring({
  frame,
  fps,
  config: {
    damping: 10,      // Resistance (higher = less bounce)
    stiffness: 100,   // Spring tension (higher = faster)
    mass: 1,          // Weight (higher = slower)
    overshootClamping: false,  // Prevent overshooting target
  },
  from: 0,            // Start value (default: 0)
  to: 1,              // End value (default: 1)
  durationInFrames: 60,  // Optional: stretch to exact duration
  delay: 0,           // Frames to wait before starting
});
```

### Spring Config Presets

```tsx
// Snappy - Quick with slight bounce
{ damping: 12, stiffness: 200, mass: 0.5 }

// Bouncy - Playful with multiple bounces
{ damping: 8, stiffness: 100, mass: 1 }

// Smooth - Gentle, no bounce
{ damping: 20, stiffness: 100, mass: 1 }

// Slow - Dramatic, heavy feel
{ damping: 15, stiffness: 50, mass: 2 }

// Elastic - Very bouncy
{ damping: 5, stiffness: 150, mass: 1 }
```

### Combining spring with interpolate

```tsx
// Spring drives 0→1, interpolate maps to actual values
const progress = spring({ frame, fps, config: { damping: 12 } });

const x = interpolate(progress, [0, 1], [-200, 0]);
const scale = interpolate(progress, [0, 1], [0.5, 1]);
const rotation = interpolate(progress, [0, 1], [-45, 0]);
```

### measureSpring()

Calculate spring duration for precise timing:
```tsx
import { measureSpring } from 'remotion';

const duration = measureSpring({
  fps: 30,
  config: { damping: 10, stiffness: 100 },
});
// Returns number of frames until spring settles
```

---

## Easing Functions

Built-in easing curves for `interpolate()`:

```tsx
import { Easing } from 'remotion';

// Usage
const value = interpolate(frame, [0, 60], [0, 100], {
  easing: Easing.ease,
});
```

### Available Easings

| Easing | Description |
|--------|-------------|
| `Easing.linear` | Constant speed |
| `Easing.ease` | Gentle acceleration/deceleration |
| `Easing.quad` | Quadratic curve |
| `Easing.cubic` | Cubic curve |
| `Easing.sin` | Sinusoidal |
| `Easing.exp` | Exponential |
| `Easing.circle` | Circular |
| `Easing.back` | Overshoots then returns |
| `Easing.elastic` | Elastic spring effect |
| `Easing.bounce` | Bouncing ball effect |

### Easing Modifiers

```tsx
// In - Starts slow, ends fast
Easing.in(Easing.quad)

// Out - Starts fast, ends slow
Easing.out(Easing.quad)

// InOut - Slow at both ends
Easing.inOut(Easing.quad)

// Custom bezier
Easing.bezier(0.42, 0, 0.58, 1)  // CSS ease-in-out equivalent
```

---

## interpolateColors()

Smooth color transitions:

```tsx
import { interpolateColors } from 'remotion';

const color = interpolateColors(
  frame,
  [0, 50, 100],                           // Input range
  ['#ff0000', '#00ff00', '#0000ff']       // Colors (hex, rgb, hsl)
);

// Usage in style
<div style={{ backgroundColor: color }} />
```

Supports: hex, rgb(), rgba(), hsl(), hsla(), and color names.

---

## Animation Patterns

### Typewriter Effect
```tsx
export const Typewriter: React.FC<{ text: string }> = ({ text }) => {
  const frame = useCurrentFrame();
  const charsToShow = Math.floor(frame / 2);  // 2 frames per character

  return <span>{text.slice(0, charsToShow)}</span>;
};
```

### Looping Animation
```tsx
export const Pulse: React.FC = () => {
  const frame = useCurrentFrame();
  const loopDuration = 30;  // frames per loop
  const loopedFrame = frame % loopDuration;

  const scale = interpolate(
    loopedFrame,
    [0, 15, 30],
    [1, 1.2, 1]
  );

  return <div style={{ transform: `scale(${scale})` }}>Pulse</div>;
};
```

### Delayed Animation
```tsx
export const DelayedFadeIn: React.FC<{ delay: number }> = ({ delay }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const opacity = spring({
    frame: frame - delay,  // Subtract delay
    fps,
    config: { damping: 15 },
  });

  return <div style={{ opacity: Math.max(0, opacity) }}>Delayed</div>;
};
```

### Parallax Scrolling
```tsx
export const Parallax: React.FC = () => {
  const frame = useCurrentFrame();

  const bgY = interpolate(frame, [0, 100], [0, -50]);
  const fgY = interpolate(frame, [0, 100], [0, -150]);

  return (
    <AbsoluteFill>
      <div style={{ transform: `translateY(${bgY}px)` }}>Background</div>
      <div style={{ transform: `translateY(${fgY}px)` }}>Foreground</div>
    </AbsoluteFill>
  );
};
```

### Stagger with Index
```tsx
export const StaggeredList: React.FC<{ items: string[] }> = ({ items }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <>
      {items.map((item, index) => {
        const delay = index * 5;  // 5 frame stagger
        const opacity = spring({
          frame: frame - delay,
          fps,
          config: { damping: 12 },
        });

        return (
          <div key={index} style={{ opacity: Math.max(0, opacity) }}>
            {item}
          </div>
        );
      })}
    </>
  );
};
```
