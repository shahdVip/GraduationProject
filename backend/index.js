const app =require('./app');
const db = require('./config/db');
const UserModel = require('./model/user.model');
const UserRequestModel = require('./model/userRequest.model');
const UserPreferenceModel = require('./model/userPreference.model');
const BouqetModel = require('./model/bouqet.model');
const MomentModel = require('./model/moment.model');

const PORT = 3000;


app.get('/',(req,res)=>{
    res.send("helloooooooooooo woorld")
});
app.listen(PORT,()=>{
    console.log(`server is listening on port http://localhost:${PORT}`);
});