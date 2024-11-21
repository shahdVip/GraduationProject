const UserModel=require('../model/user.model')

class UserService {
    static async registerUser({ email, password, phoneNumber, address, profilePhoto, username, role }) {
        try {
            const createUser = new UserModel({
                email,
                password,
                phoneNumber,
                address,
                profilePhoto,
                username,
                role
            });

            // The password hashing will happen in the model's `pre` save hook

            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }
}

module.exports=UserService;