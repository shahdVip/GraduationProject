const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://localhost:27017/Rozeh1').on('open',()=>{
    console.log("mongodb connected..");
}).on('error',()=>{
    console.log("mongodb connection error..");
});

module.exports = connection;