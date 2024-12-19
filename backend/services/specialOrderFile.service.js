const fs = require("fs");
const path = require("path");

// const saveFile = (req) => {
//   return new Promise((resolve, reject) => {
//     const filePath = path.join(
//       process.cwd(), // Gets the root directory of your project
//       "..",
//       "grad_roze",
//       "assets",
//       "specialOrders",
//       `bouquet_${Date.now()}.glb`
//     );

//     const writeStream = fs.createWriteStream(filePath);

//     // Pipe the request to the file
//     req.pipe(writeStream);

//     // Handle stream events
//     req.on("end", () => resolve());
//     req.on("error", (err) => reject(err));
//   });
// };
const saveFile = (req, res) => {
  return new Promise((resolve, reject) => {
    const fileName = `bouquet_${Date.now()}.glb`;
    const filePath = path.join(
      process.cwd(),
      "..",
      "grad_roze",
      "assets",
      "specialOrders",
      fileName
    );

    const writeStream = fs.createWriteStream(filePath);
    req.pipe(writeStream);

    req.on("end", () => {
      res.json({ fileName }); // Send the response here
      resolve(fileName); // Resolve the Promise with the file name
    });

    req.on("error", (err) => {
      res.status(500).send("File upload failed");
      reject(err);
    });
  });
};

module.exports = {
  saveFile,
};
