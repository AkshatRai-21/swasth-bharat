const express = require("express");
const router = express.Router();
const { body } = require("express-validator");
const { signIn, signUp } = require("../controllers/userAuthController");

const userValidation = [
  body("name").notEmpty().withMessage("Name is required"),
  body("email").isEmail().withMessage("Invalid email format"),
  body("password")
    .isLength({ min: 5 })
    .withMessage("Password must be at least 5 characters long"),
];

// Sign-in route
router.post("/signin", signIn);

// Sign-up route
router.post("/signup", userValidation, signUp);

module.exports = router;
