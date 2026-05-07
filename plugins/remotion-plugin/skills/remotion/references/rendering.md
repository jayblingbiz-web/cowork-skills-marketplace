# Remotion Rendering Reference

## Table of Contents
- [CLI Rendering](#cli-rendering)
- [Codecs and Formats](#codecs-and-formats)
- [Quality Settings](#quality-settings)
- [Advanced Options](#advanced-options)
- [Still Images](#still-images)
- [Lambda Deployment](#lambda-deployment)

---

## CLI Rendering

### Basic Command

```bash
npx remotion render <entry-point> <composition-id> <output>
```

Entry point is optional if `remotion.config.ts` exists:
```bash
npx remotion render MyVideo out/video.mp4
```

### Common Examples

```bash
# Render to MP4
npx remotion render MyVideo output.mp4

# Render to WebM
npx remotion render MyVideo output.webm --codec=vp9

# Render specific frames only
npx remotion render MyVideo output.mp4 --frames=0-89

# Render with props
npx remotion render MyVideo output.mp4 --props='{"title":"Hello"}'
```

---

## Codecs and Formats

### Video Codecs

| Codec | Extension | Use Case |
|-------|-----------|----------|
| `h264` | .mp4 | Default, wide compatibility |
| `h265` | .mp4 | Better compression, less support |
| `vp8` | .webm | Web, older browsers |
| `vp9` | .webm | Web, better quality than vp8 |
| `prores` | .mov | Professional editing, lossless |
| `h264-mkv` | .mkv | Alternative container |

```bash
npx remotion render MyVideo out.mp4 --codec=h264
npx remotion render MyVideo out.webm --codec=vp9
npx remotion render MyVideo out.mov --codec=prores
```

### ProRes Profiles

```bash
--prores-profile=4444-xq  # Highest quality, with alpha
--prores-profile=4444     # High quality, with alpha
--prores-profile=hq       # High quality
--prores-profile=standard # Standard quality
--prores-profile=light    # Smaller files
--prores-profile=proxy    # Smallest, for editing
```

### Audio Codecs

| Codec | Description |
|-------|-------------|
| `aac` | Default for MP4 |
| `mp3` | Wide compatibility |
| `wav` | Uncompressed |
| `opus` | Modern, efficient |

```bash
--audio-codec=aac
--audio-bitrate=320k
```

---

## Quality Settings

### CRF (Constant Rate Factor)

Lower = better quality, larger file. Range 0-51, default 18.

```bash
npx remotion render MyVideo out.mp4 --crf=15   # High quality
npx remotion render MyVideo out.mp4 --crf=23   # Smaller file
npx remotion render MyVideo out.mp4 --crf=28   # Low quality
```

### Bitrate

Alternative to CRF for precise file size control:

```bash
--video-bitrate=8M    # 8 Mbps
--video-bitrate=4000k # 4000 kbps
```

### JPEG Quality (for image sequences)

```bash
--jpeg-quality=90  # 0-100
```

---

## Advanced Options

### Performance

```bash
# Use multiple CPU cores
--concurrency=50%     # Use half of cores
--concurrency=4       # Use 4 cores

# Memory and timeouts
--timeout=60000       # 60 second timeout per frame
```

### Scaling

```bash
--scale=2    # Render at 2x resolution
--scale=0.5  # Render at half resolution
```

### Frame Range

```bash
--frames=0-59         # First 60 frames
--frames=100-199      # Frames 100-199
--every-nth-frame=2   # Render every 2nd frame
```

### Output Options

```bash
--overwrite           # Overwrite existing file
--muted               # No audio
--enforce-audio-track # Force audio even if silent
--number-of-gif-loops=0  # Infinite GIF loop
```

### Image Sequences

```bash
npx remotion render MyVideo frames/ --image-format=png --sequence
npx remotion render MyVideo frames/ --image-format=jpeg --sequence
```

---

## Still Images

Render a single frame as an image:

```bash
npx remotion still <composition-id> <output> --frame=<number>
```

Examples:
```bash
npx remotion still MyVideo thumbnail.png --frame=0
npx remotion still MyVideo poster.jpg --frame=45 --image-format=jpeg
```

---

## Lambda Deployment

Render videos serverlessly on AWS Lambda.

### Setup

```bash
npm install @remotion/lambda
npx remotion lambda policies role    # Create IAM role
npx remotion lambda sites create     # Deploy site to S3
npx remotion lambda functions deploy # Deploy Lambda function
```

### Render on Lambda

```tsx
import { renderMediaOnLambda } from '@remotion/lambda';

const result = await renderMediaOnLambda({
  region: 'us-east-1',
  functionName: 'remotion-render',
  composition: 'MyVideo',
  serveUrl: 'https://your-bucket.s3.amazonaws.com/sites/your-site',
  codec: 'h264',
  inputProps: { title: 'Hello' },
});

// result.outputFile contains S3 URL of rendered video
```

### Monitor Progress

```tsx
import { getRenderProgress } from '@remotion/lambda';

const progress = await getRenderProgress({
  region: 'us-east-1',
  functionName: 'remotion-render',
  bucketName: 'your-bucket',
  renderId: result.renderId,
});

console.log(`${progress.overallProgress * 100}% complete`);
```

### Cost Optimization

- Use `concurrencyPerLambda` to control parallel rendering
- Set appropriate `timeoutInMilliseconds`
- Use `framesPerLambda` to batch frames

```tsx
await renderMediaOnLambda({
  // ... other options
  framesPerLambda: 20,
  concurrencyPerLambda: 1,
  timeoutInMilliseconds: 120000,
});
```
