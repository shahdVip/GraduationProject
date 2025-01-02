import React from "react";

const SuccessDialog = ({ message, onClose }) => {
  return (
    <div
      style={{
        position: "fixed",
        top: "0",
        left: "0",
        right: "0",
        bottom: "0",
        backgroundColor: "rgba(0, 0, 0, 0.5)",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        zIndex: 1000, // Ensure the background is above other content
      }}
    >
      <div
        style={{
          backgroundColor: "white",
          padding: "20px",
          borderRadius: "8px",
          textAlign: "center",
          zIndex: 2000, // Ensure the modal itself is above the background
        }}
      >
        <h3>{message}</h3>
        <button
          onClick={onClose} // This triggers the closing of the modal
          style={{
            backgroundColor: "#040425",
            color: "white",
            padding: "10px 20px",
            border: "none",
            borderRadius: "5px",
            cursor: "pointer", // Add cursor pointer
            pointerEvents: "auto", // Ensure button can be clicked
          }}
        >
          Close
        </button>
      </div>
    </div>
  );
};

export default SuccessDialog;
