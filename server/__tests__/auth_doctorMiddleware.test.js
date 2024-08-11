const admin = require("../middleware/auth_doctor");
const jwt = require("jsonwebtoken");
const Doctor = require("../models/doctor");

// Mock Doctor model
jest.mock("../models/doctor");

describe("Admin Middleware", () => {
  beforeEach(() => {
    Doctor.findById = jest.fn();
  });

  it("should call next() if the token is valid and doctor is found", async () => {
    const token = jwt.sign({ id: "doctorId123" }, "passwordKey");
    Doctor.findById.mockResolvedValue({ _id: "doctorId123" });

    const req = {
      header: jest.fn().mockReturnValue(token),
    };
    const res = {};
    const next = jest.fn();

    await admin(req, res, next);

    expect(Doctor.findById).toHaveBeenCalledWith("doctorId123");
    expect(next).toHaveBeenCalled();
  });

  it("should return 401 if no token is provided", async () => {
    const req = {
      header: jest.fn().mockReturnValue(null),
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };
    const next = jest.fn();

    await admin(req, res, next);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({ msg: "No auth token, access denied" });
  });


  it("should return 500 if an error occurs", async () => {
    const token = jwt.sign({ id: "doctorId123" }, "passwordKey");
    Doctor.findById.mockRejectedValue(new Error("Test error"));

    const req = {
      header: jest.fn().mockReturnValue(token),
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };
    const next = jest.fn();

    await admin(req, res, next);

    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith({ error: "Test error" });
  });
});
