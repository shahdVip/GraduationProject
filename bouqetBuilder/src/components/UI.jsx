import { useEffect, useState } from "react";
import { useConfiguratorStore } from "../store";
import SuccessDialog from "../SuccessDialog"; // Import the SuccessDialog component

const AssetsBox = () => {
  const {
    categories = [], // Default to an empty array
    currentCategory,
    fetchCategories,
    setCurrentCategory,
    changeAsset,
    customization,
    updateFlowerCount,
  } = useConfiguratorStore();

  const [flowerCount, setFlowerCount] = useState(1);

  useEffect(() => {
    const fetchData = async () => {
      await fetchCategories(); // Fetch categories once
      console.log("Fetched categories:", categories);
      console.log(
        "Current category assets:",
        currentCategory?.assets || "No assets"
      );
    };

    fetchData();
  }, [fetchCategories]); // Only call on mount or if fetchCategories changes

  const handleFlowerCountChange = (count) => {
    updateFlowerCount(currentCategory?.name, count);
  };

  return (
    <div className="rounded-t-lg bg-gradient-to-br from-black/30 to-indigo-900/20 drop-shadow-md flex flex-col py-6 gap-3 backdrop-blur-sm">
      {/* Category buttons */}
      <div className="flex items-center gap-8 pointer-events-auto overflow-x-auto noscrollbar px-6 pb-2">
        {categories.map((category) => (
          <button
            key={category._id}
            onClick={() => setCurrentCategory(category)}
            className={`transition-colors duration-200 font-medium flex-shrink-0 border-b ${
              currentCategory?.name === category.name
                ? "text-white shadow-purple-100 border-b-white"
                : "text-gray-400 hover:text-gray-500 border-b-transparent"
            }`}
          >
            {category.name}
          </button>
        ))}
      </div>

      {/* Assets display */}
      <div className="flex items-center gap-1 pointer-events-auto overflow-x-auto px-6 pb-2 noscrollbar">
        {currentCategory?.removable && (
          <button
            onClick={() => changeAsset(currentCategory.name, null)}
            className={`w-20 h-20 flex-shrink-0 rounded-xl overflow-hidden pointer-events-auto hover:opacity-100 transition-all border-2 duration-300 ${
              !customization[currentCategory?.name]?.asset
                ? "border-white opacity-100"
                : "opacity-80 border-transparent"
            }`}
          >
            <div className="w-full h-full flex items-center justify-center bg-black/40 text-white">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="size-8"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M6 18 18 6M6 6l12 12"
                />
              </svg>
            </div>
          </button>
        )}

        {/* Asset buttons */}
        {currentCategory?.assets?.length > 0 ? (
          currentCategory?.assets.map((asset) => (
            <button
              key={asset._id}
              onClick={() => changeAsset(currentCategory.name, asset)}
              className={`w-20 h-20 flex-shrink-0 rounded-xl overflow-hidden bg-gray-200 pointer-events-auto hover:opacity-100 transition-all border-2 duration-300 ${
                customization[currentCategory?.name]?.asset?.id !== asset.id
                  ? "border-white opacity-100"
                  : "opacity-80 border-transparent"
              }`}
            >
              <img
                className="object-cover w-full h-full"
                src={`http://192.168.1.29:5173/src${asset.thumbnail}`}
                alt={asset.name}
              />
            </button>
          ))
        ) : (
          <p>No assets available</p>
        )}
      </div>

      {/* Flower Count Slider */}
      <FlowerCountInput
        flowerCount={flowerCount}
        setFlowerCount={setFlowerCount}
        onChange={handleFlowerCountChange}
        currentAssetName={currentCategory?.name}
      />
    </div>
  );
};

const ScreenshotButton = () => {
  const screenshot = useConfiguratorStore((state) => state.screenshot);
  return (
    <button
      className="rounded-lg bg-[#040425] hover:bg-[#040425] transition-colors duration-300 text-white font-medium px-4 py-3 pointer-events-auto drop-shadow-md"
      onClick={screenshot}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        strokeWidth={1.5}
        stroke="currentColor"
        className="size-6"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M6.827 6.175A2.31 2.31 0 0 1 5.186 7.23c-.38.054-.757.112-1.134.175C2.999 7.58 2.25 8.507 2.25 9.574V18a2.25 2.25 0 0 0 2.25 2.25h15A2.25 2.25 0 0 0 21.75 18V9.574c0-1.067-.75-1.994-1.802-2.169a47.865 47.865 0 0 0-1.134-.175 2.31 2.31 0 0 1-1.64-1.055l-.822-1.316a2.192 2.192 0 0 0-1.736-1.039 48.774 48.774 0 0 0-5.232 0 2.192 2.192 0 0 0-1.736 1.039l-.821 1.316Z"
        />
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M16.5 12.75a4.5 4.5 0 1 1-9 0 4.5 4.5 0 0 1 9 0ZM18.75 10.5h.008v.008h-.008V10.5Z"
        />
      </svg>
    </button>
  );
};

const RandomizeButton = () => {
  const randomize = useConfiguratorStore((state) => state.randomize);
  return (
    <button
      className="rounded-lg bg-[#040425] hover:bg-[#040425] transition-colors duration-300 text-white font-medium px-4 py-3 pointer-events-auto drop-shadow-md"
      onClick={randomize}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        strokeWidth={1.5}
        stroke="currentColor"
        className="size-6"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M19.5 12c0-1.232-.046-2.453-.138-3.662a4.006 4.006 0 0 0-3.7-3.7 48.678 48.678 0 0 0-7.324 0 4.006 4.006 0 0 0-3.7 3.7c-.017.22-.032.441-.046.662M19.5 12l3-3m-3 3-3-3m-12 3c0 1.232.046 2.453.138 3.662a4.006 4.006 0 0 0 3.7 3.7 48.656 48.656 0 0 0 7.324 0 4.006 4.006 0 0 0 3.7-3.7c.017-.22.032-.441.046-.662M4.5 12l3 3m-3-3-3 3"
        />
      </svg>
    </button>
  );
};

const DownloadButton = () => {
  const download = useConfiguratorStore((state) => state.download);
  return (
    <button
      className="rounded-lg bg-[#040425] hover:bg-[#040425] transition-colors duration-300 text-white font-medium px-4 py-3 pointer-events-auto drop-shadow-md"
      onClick={download}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        strokeWidth={1.5}
        stroke="currentColor"
        className="size-6"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M12 4v16m0 0 6-6m-6 6-6-6"
        />
      </svg>
    </button>
  );
};

const OrderButton = () => {
  // Get the placeOrder function from the store
  const placeOrder = useConfiguratorStore((state) => state.placeOrder);

  return (
    <button
      className="rounded-lg bg-[#040425] hover:bg-[#040425] transition-colors duration-300 text-white font-medium px-4 py-3 pointer-events-auto drop-shadow-md"
      onClick={placeOrder} // Call placeOrder when the button is clicked
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        strokeWidth={1.5}
        stroke="currentColor"
        className="size-6"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M12 4v16m0 0 6-6m-6 6-6-6"
        />
      </svg>
    </button>
  );
};

const CombinedButton = () => {
  const [showSuccessDialog, setShowSuccessDialog] = useState(false); // State to control the dialog visibility
  const download = useConfiguratorStore((state) => state.download);
  // const placeOrder = useConfiguratorStore((state) => state.placeOrder);

  // const handleButtonClick = async () => {
  //   if (!download) {
  //     console.error("Download function is not yet available.");
  //     return;
  //   }
  //   try {
  //     console.log("Download function:", download);

  //     const fileName = await download(); // Call the download function and wait for the result
  //     console.log("File name received from download:", fileName); // Now log the actual file name

  //     // Call placeOrder with the obtained fileName
  //     //await placeOrder(fileName);

  //     // Show the success dialog after the order is placed successfully
  //     setShowSuccessDialog(true);
  //   } catch (error) {
  //     console.error("Error executing button actions:", error);
  //   }
  // };

  const handleCloseDialog = () => {
    setShowSuccessDialog(false); // Close the dialog
  };

  return (
    <div>
      <button
        className="rounded-lg bg-[#040425] hover:bg-[#040425] transition-colors duration-300 text-white font-medium px-4 py-3 pointer-events-auto drop-shadow-md"
        onClick={download} // Call both actions when the button is clicked
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          strokeWidth={1.5}
          stroke="currentColor"
          className="size-6"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M12 4v16m0 0 6-6m-6 6-6-6"
          />
        </svg>
      </button>

      {/* Show SuccessDialog when order is placed */}
      {showSuccessDialog && (
        <SuccessDialog
          message="Your order has been placed successfully!"
          onClose={handleCloseDialog} // Pass the close handler to the dialog
        />
      )}
    </div>
  );
};

export const UI = () => {
  const currentCategory = useConfiguratorStore(
    (state) => state.currentCategory
  );
  const customization = useConfiguratorStore((state) => state.customization);
  return (
    <main className="pointer-events-none fixed z-10 inset-0 select-none">
      <div className="mx-auto h-full max-w-screen-xl w-full flex flex-col justify-between">
        <div className="flex justify-between items-center p-10">
          <a className="pointer-events-auto" href="">
            <h1 className="text-white pl-[5px] font-bold">
              Roze` Bouquet Builder
            </h1>
          </a>
          <div className="flex items-cente gap-2">
            <RandomizeButton />
            <ScreenshotButton />
            {/* <DownloadButton />
            <OrderButton /> */}
            <CombinedButton />
          </div>
        </div>
        <div className="px-10 flex flex-col">
          {/* Ensure colorPalette exists before rendering */}
          {currentCategory?.colorPalette &&
            customization[currentCategory.name] && <ColorPicker />}
          <AssetsBox />
        </div>

        {/* <div className="px-10 flex flex-col ">
          {currentCategory?.colorPalette &&
            customization[currentCategory.name] && <ColorPicker />}
          <AssetsBox />
        </div> */}
      </div>
    </main>
  );
};

const FlowerCountInput = ({ currentAssetName, onChange }) => {
  const { currentCategory, customization } = useConfiguratorStore();
  const categoryName = currentCategory?.name;
  const flowerCount = categoryName && customization[categoryName]?.flowerCount;

  const handleInputChange = (e) => {
    const count = parseInt(e.target.value, 10);
    onChange(count); // Call onChange directly
  };

  if (currentAssetName?.toLowerCase() === "vase") {
    return null; // Don't render if asset is vase
  }

  return (
    <div className="relative z-10 pointer-events-auto">
      <label htmlFor="flowerCount" className="text-white pl-[5px]">
        Number of Flowers:
      </label>
      <input
        id="flowerCount"
        type="text"
        inputMode="numeric"
        pattern="\d*"
        value={flowerCount}
        onChange={handleInputChange}
        className="ml-2 border rounded px-2 py-1"
        style={{ width: "50px" }}
      />
    </div>
  );
};

const ColorPicker = () => {
  const updateColor = useConfiguratorStore((state) => state.updateColor);
  const currentCategory = useConfiguratorStore(
    (state) => state.currentCategory
  );
  const customization = useConfiguratorStore((state) => state.customization);

  // Return null if there's no asset in the current category customization
  if (!customization[currentCategory?.name]?.asset) {
    return null;
  }

  // Check if colorPalette exists and contains colors
  const colors = currentCategory?.colorPalette?.colors || [];

  return (
    <div className="pointer-events-auto relative flex gap-2 max-w-full overflow-x-auto backdrop-blur-sm py-2 drop-shadow-md">
      {colors.length > 0 ? (
        colors.map((color, index) => (
          <button
            key={`${index}-${color}`}
            className={`w-10 h-10 p-1.5 drop-shadow-md bg-black/20 shrink-0 rounded-lg transition-all duration-300 border-2 overflow-hidden ${
              customization[currentCategory.name]?.color === color
                ? "border-white"
                : "border-transparent"
            }`}
            onClick={() => updateColor(color)}
          >
            <div
              className="w-full h-full rounded-md"
              style={{ background: color }}
            ></div>
          </button>
        ))
      ) : (
        <p className="text-gray-500">No colors available</p>
      )}
    </div>
  );
};

// const ColorPicker = () => {
//   const updateColor = useConfiguratorStore((state) => state.updateColor);
//   const currentCategory = useConfiguratorStore(
//     (state) => state.currentCategory
//   );
//   const handleColorChange = (color) => {
//     updateColor(color);
//   };
//   const customization = useConfiguratorStore((state) => state.customization);
//   if (!customization[currentCategory.name]?.asset) {
//     return null;
//   }
//   return (
//     <div className="pointer-events-auto relative flex gap-2 max-w-full overflow-x-auto backdrop-blur-sm py-2 drop-shadow-md">
//       {currentCategory.expand?.colorPalette?.colors.map((color, index) => (
//         <button
//           key={`${index}-${color}`}
//           className={`w-10 h-10 p-1.5 drop-shadow-md bg-black/20 shrink-0 rounded-lg transition-all duration-300 border-2 overflow-hidden ${
//             customization[currentCategory.name]?.color === color
//               ? "border-white"
//               : "border-transparent"
//           }`}
//           onClick={() => handleColorChange(color)}
//         >
//           <div
//             className="w-full h-full rounded-md"
//             style={{ background: color }}
//           ></div>
//         </button>
//       ))}
//     </div>
//   );
// };
