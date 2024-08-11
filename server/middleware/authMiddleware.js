const jwt = require("jsonwebtoken");
const Doctor = require("../models/doctor");
// const User = require("../models/user");

module.exports = function (req, res, next) {
  const token = req.header("x-auth-token");
  if (!token) {
    return res.status(401).json({ msg: "No token, authorization denied" });
  }

  try {
    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET || "JCDKJCFKDSLFJSDAFJDLCFJDSLKFJDLKFLFDSAKF"
    );

    req.doctor = decoded.Doctor;
    next();
  } catch (err) {
    res.status(401).json({ msg: "Token is not valid" });
  }
};
