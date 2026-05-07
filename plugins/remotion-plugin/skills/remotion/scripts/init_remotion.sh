#!/bin/bash
# Initialize a new Remotion project

set -e

PROJECT_NAME="${1:-my-remotion-video}"

if [ -d "$PROJECT_NAME" ]; then
  echo "Error: Directory '$PROJECT_NAME' already exists"
  exit 1
fi

echo "Creating Remotion project: $PROJECT_NAME"

# Create project structure
mkdir -p "$PROJECT_NAME/src" "$PROJECT_NAME/public"
cd "$PROJECT_NAME"

# Initialize package.json
cat > package.json << 'EOF'
{
  "name": "remotion-video",
  "version": "1.0.0",
  "scripts": {
    "start": "remotion studio",
    "build": "remotion render",
    "render": "remotion render"
  }
}
EOF

# Install dependencies
npm install remotion @remotion/cli react react-dom typescript @types/react --silent

# Create tsconfig
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2018",
    "module": "commonjs",
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "moduleResolution": "node"
  },
  "include": ["src"]
}
EOF

# Create entry point
cat > src/index.ts << 'EOF'
import { registerRoot } from 'remotion';
import { RemotionRoot } from './Root';

registerRoot(RemotionRoot);
EOF

# Create Root component
cat > src/Root.tsx << 'EOF'
import React from 'react';
import { Composition } from 'remotion';
import { MyVideo } from './MyVideo';

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="MyVideo"
      component={MyVideo}
      durationInFrames={150}
      fps={30}
      width={1920}
      height={1080}
    />
  );
};
EOF

# Create sample video component
cat > src/MyVideo.tsx << 'EOF'
import React from 'react';
import { AbsoluteFill, useCurrentFrame, interpolate } from 'remotion';

export const MyVideo: React.FC = () => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 30], [0, 1], { extrapolateRight: 'clamp' });

  return (
    <AbsoluteFill style={{ backgroundColor: '#111', justifyContent: 'center', alignItems: 'center' }}>
      <div style={{ color: 'white', fontSize: 80, fontFamily: 'system-ui', opacity }}>
        Hello Remotion
      </div>
    </AbsoluteFill>
  );
};
EOF

echo ""
echo "✅ Project created: $PROJECT_NAME"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  npm start              # Open Remotion Studio"
echo "  npx remotion render MyVideo out.mp4"
