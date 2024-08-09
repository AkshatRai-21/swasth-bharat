const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const { validationResult } = require("express-validator");
const User = require("../models/user");

const JWT_SECRET = process.env.JWT_SECRET;

// Sign-in Controller
exports.signIn = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      return res
        .status(403)
        .json({ mssg: "User with this email does not exist" });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ mssg: "Incorrect password" });
    }
    const userId = user._id;
    const token = jwt.sign({ userId }, JWT_SECRET);
    res.json({ mssg: "Logged in", token: token });
  } catch (e) {
    console.error(e);
    return res
      .status(500)
      .json({ mssg: "Something went wrong", error: e.message });
  }
};

// Sign-up Controller
exports.signUp = async (req, res) => {
  try {
    // Validate request data
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password } = req.body;

    // Check if the email is already in use
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ mssg: "Email is already in use" });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create and save new user
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
    });
    const userId = newUser._id;
    const token = jwt.sign({ userId }, JWT_SECRET);
    await newUser.save();
    res.json({ mssg: "User created", newUser, token });
  } catch (e) {
    console.error(e);
    return res.status(500).json({
      mssg: "An error occurred while creating the user",
      error: e.message,
    });
  }
};
