import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import { Canvas } from "@react-three/fiber";
import { UI } from "./components/UI";
import { Experience } from "./components/Experience";
function App() {
  return (
    <>
      <UI />
      <Canvas
        camera={{ position: [-1.5, 1, 5], fov: 75 }}
        gl={{
          preserveDrawingBuffer: true,
        }}
        shadows
      >
        <color attach={"background"} args={["#555"]} />
        <fog attach={"fog"} args={["#555", 15, 25]} />
        <group position-y={-0.5}>
          <Experience />
        </group>
      </Canvas>
    </>
  );
}

export default App;
