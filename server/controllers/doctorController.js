const Doctor = require("../models/doctor"); // Ensure this path is correct
const haversine = require("../utils/haversine"); // If you use haversine function for distance calculation

// Get all doctors
const getAllDoctor = async (req, res) => {
  try {
    // Fetch all doctors
    const doctors = await Doctor.find();
    // Send the list of doctors as JSON
    res.json(doctors);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};
// Get doctors by specialty
const speciality = async (req, res) => {
  const { specialty } = req.query;

  if (!specialty) {
    return res.status(400).json({ msg: "Specialty is required" });
  }

  try {
    // Use case-insensitive regex to match the specialty
    const doctors = await Doctor.find({
      specialty: new RegExp(specialty, "i"),
    });

    if (doctors.length === 0) {
      return res
        .status(404)
        .json({ msg: "No doctors found with this specialty" });
    }

    // Send the list of doctors as JSON
    res.json(doctors);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};
// Get doctors near a location
const nearestDoctor = async (req, res) => {
  const { latitude, longitude, radius } = req.query;

  if (!latitude || !longitude || !radius) {
    return res
      .status(400)
      .json({ msg: "Latitude, longitude, and radius are required" });
  }

  const userLat = parseFloat(latitude);
  const userLon = parseFloat(longitude);
  const searchRadius = parseFloat(radius);

  if (isNaN(userLat) || isNaN(userLon) || isNaN(searchRadius)) {
    return res
      .status(400)
      .json({ msg: "Invalid latitude, longitude, or radius" });
  }

  try {
    // Fetch doctors using geospatial query
    const nearbyDoctors = await Doctor.find({
      location: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: [userLon, userLat],
          },
          $maxDistance: searchRadius * 1000, // Convert km to meters
        },
      },
    });

    // Calculate distance for each doctor
    const result = nearbyDoctors.map((doctor) => {
      const distance = haversine(userLat, userLon, doctor.Lat, doctor.Long);
      return {
        name: doctor.name,
        specialty: doctor.specialty,
        distance,
      };
    });

    // Send the list of doctors with distance as JSON
    res.json(result);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};
module.exports = {
  getAllDoctor,
  speciality,
  nearestDoctor,
};
