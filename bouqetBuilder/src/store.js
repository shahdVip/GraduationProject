import { create } from "zustand";
import axios from "axios";
import { randInt } from "three/src/math/MathUtils.js";


const apiUrl = "http://192.168.1.29:3000";


export const useConfiguratorStore = create((set, get) => ({
  categories: [],
  currentCategory: null,
  assets: [],
  customization: {},
  download: () => {},

  setDownload: (download) => set({ download }),
  fetchCategories: async () => {
    try {
      // Call the correct API endpoint: /groups-with-assets
      const response = await axios.get(`${apiUrl}/groups-with-assets`);
      const groupsWithAssets = response.data;

      // Ensure the response is an array
      if (Array.isArray(groupsWithAssets)) {
        const assets = groupsWithAssets.map((group) => group.assets); // Extract assets for each group
        const customization = {};

        // Initialize customization based on groups (categories)
        groupsWithAssets.forEach((group) => {
          customization[group.name] = {
            color: group.colorPalette?.colors?.[0] || "", // Default to the first color if available
            flowerCount: 1, // Default flower count
          };
        });

        set({
          categories: groupsWithAssets, // Now this contains both groups and their assets
          currentCategory: groupsWithAssets[0], // Set the first category as the current one
          assets: assets.flat(), // Flatten assets into one array
          customization,
        });
      } else {
        console.error("Response is not an array:", groupsWithAssets);
      }
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  },

  setCurrentCategory: (category) => set({ currentCategory: category }),

  updateFlowerCount: (categoryName, count) => {
    set((state) => {
      const updatedCustomization = {
        ...state.customization,
        [categoryName]: {
          ...state.customization[categoryName],
          flowerCount: count, // Update flower count for the category
        },
      };
      return { customization: updatedCustomization };
    });
  },
  changeAsset: (category, asset) => {
    set((state) => {
      const vasePosition = state.vasePosition || [0, 0, 0]; // Default vase position
      return {
        customization: {
          ...state.customization,
          [category]: {
            ...state.customization[category],
            asset: {
              ...asset,
              position: vasePosition, // Assign vase position to asset
            },
            flowerCount: 1, // Reset flower count when an asset changes
          },
        },
      };
    });
  },

  screenshot: () => {},
  setScreenshot: (screenshot) => set({ screenshot }),
  updateColor: (color) => {
    set((state) => ({
      customization: {
        ...state.customization,
        [state.currentCategory.name]: {
          ...state.customization[state.currentCategory.name],
          color,
        },
      },
    }));
  },

  randomize: () => {
    const customization = {};
    get().categories.forEach((category) => {
      console.log("Category Object:", category); // Log the category object for debugging

      const randomIndex = randInt(0, 2);
      let randomAsset = category.assets[randomIndex];

      // Access colorPalette directly
      const colorPalette =
        category.colorPalette?.colors &&
        Array.isArray(category.colorPalette.colors)
          ? category.colorPalette.colors
          : [];
      console.log("Color Palette:", colorPalette);

      // Generate a random color
      const randomColor =
        colorPalette.length > 0
          ? colorPalette[randInt(0, colorPalette.length - 1)]
          : null; // Default to null if no colors are available
      console.log("Random Color Selected:", randomColor);

      // Randomize flower count for certain categories
      const flowerCategories = ["Flower1", "Flower2", "Greenery"];
      const randomFlowerCount = flowerCategories.includes(category.name)
        ? randInt(1, 10)
        : 1;

      // // Ensure the count for "Vase" is always 1
      // if (category.name === "Vase") {
      //   randomFlowerCount = 1;
      // }
      // Handle removable assets
      if (
        category.removable &&
        randomIndex === 0 &&
        category.name !== "Vase" &&
        category.name !== "Flower1"
      ) {
        randomAsset = ""; // Set to an empty string instead of null
      }

      customization[category.name] = {
        asset: randomAsset,
        color: randomColor || "defaultColor", // Use "defaultColor" if no color is selected
        flowerCount: randomFlowerCount,
      };
    });

    console.log("Customization:", customization);

    set({ customization });
  },

  placeOrder: () => {
    try {
      const customizationData = get().customization;

      // Map customization data to the expected structure
      const selectedAssets = Object.keys(customizationData).map(
        (categoryName) => {
          const categoryCustomization = customizationData[categoryName];
          return {
            categoryName,
            asset: categoryCustomization.asset?.name, // Assuming asset contains an id
            color: categoryCustomization.color,
            flowerCount: categoryCustomization.flowerCount, // Include flowerCount
          };
        }
      );

      const flowerCount =
        Object.values(customizationData).reduce(
          (total, categoryCustomization) =>
            total + categoryCustomization.flowerCount,
          0
        ) - 1;

      console.log("Order placed successfully:", {
        selectedAssets,
        flowerCount,
      });
      return { selectedAssets, flowerCount };
    } catch (error) {
      console.error("Error placing order:", error);
      return { selectedAssets: [], flowerCount: 0 };
    }
  },

  // Other methods...
}));

// import { create } from "zustand";

// import PocketBase from "pocketbase";
// import { MeshStandardMaterial } from "three";
// import { randInt } from "three/src/math/MathUtils.js";

// const pocketBaseUrl = import.meta.env.VITE_POCKETBASE_URL;
// if (!pocketBaseUrl) {
//   throw new Error("VITE_POCKETBASE_URL is required");
// }

// export const pb = new PocketBase(pocketBaseUrl);

// export const useConfiguratorStore = create((set, get) => ({
//   categories: [],
//   currentCategory: null,
//   assets: [],
//   skin: new MeshStandardMaterial({ color: 0xffcc99, roughness: 1 }),
//   customization: {},
//   download: () => {},

//   // Update the flower count for a specific flower category

//   // Update the flower count for a specific flower category
//   updateFlowerCount: (categoryName, count) => {
//     set((state) => {
//       const updatedCustomization = {
//         ...state.customization,
//         [categoryName]: {
//           ...state.customization[categoryName],
//           flowerCount: count, // Update flower count for the category
//         },
//       };
//       return { customization: updatedCustomization };
//     });
//   },

//   setDownload: (download) => set({ download }),
//   screenshot: () => {},
//   setScreenshot: (screenshot) => set({ screenshot }),
//   updateColor: (color) => {
//     set((state) => ({
//       customization: {
//         ...state.customization,
//         [state.currentCategory.name]: {
//           ...state.customization[state.currentCategory.name],
//           color,
//         },
//       },
//     }));
//   },
//   updateSkin: (color) => {
//     get().skin.color.set(color);
//   },

//   randomize: () => {
//     const customization = {};
//     get().categories.forEach((category) => {
//       const randomIndex = randInt(0, category.assets.length - 1);
//       let randomAsset = category.assets[randomIndex];
//       const randomColor =
//         category.expand?.colorPalette?.colors?.[
//           randInt(0, category.expand.colorPalette.colors.length - 1)
//         ];

//       // Randomize flower count for certain categories
//       const flowerCategories = ["Flower1", "Flower2", "Greenery"];
//       const randomFlowerCount = flowerCategories.includes(category.name)
//         ? randInt(1, 10)
//         : 1;

//       // Handle removable assets
//       if (
//         category.removable &&
//         randomIndex === 0 &&
//         category.name !== "Vase" &&
//         category.name !== "Flower1"
//       ) {
//         randomAsset = null;
//       }

//       customization[category.name] = {
//         asset: randomAsset,
//         color: randomColor,
//         flowerCount: randomFlowerCount,
//       };
//     });
//     console.log("Customization:", customization);

//     set({ customization });
//   },

//   fetchCategories: async () => {
//     // you can also fetch all records at once via getFullList
//     const categories = await pb.collection("customizationGroups").getFullList({
//       sort: "+position",
//       expand: "colorPalette",
//     });
//     const assets = await pb.collection("customizationAssets").getFullList({
//       sort: "-created",
//     });
//     const customization = {};
//     categories.forEach((category) => {
//       category.assets = assets.filter((asset) => asset.group === category.id);
//       customization[category.name] = {
//         color: category.expand?.color?.[0] || "",
//         flowerCount: 1,
//       };
//     });

//     set({ categories, currentCategory: categories[0], assets, customization });
//   },
//   setCurrentCategory: (category) => set({ currentCategory: category }),
//   changeAsset: (category, asset) => {
//     set((state) => {
//       const vasePosition = state.vasePosition || [0, 0, 0]; // Default vase position
//       return {
//         customization: {
//           ...state.customization,
//           [category]: {
//             ...state.customization[category],
//             asset: {
//               ...asset,
//               position: vasePosition, // Assign vase position to asset
//             },
//             flowerCount: 1, // Reset flower count when an asset changes
//           },
//         },
//       };
//     });
//   },
// }));
