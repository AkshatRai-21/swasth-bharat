const { signIn } = require("../controllers/userAuthController"); // Adjust the path to your controller file
const User = require("../models/user");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

// Mock dependencies
jest.mock("../models/user");
jest.mock("bcrypt");
jest.mock("jsonwebtoken");

describe("signIn", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("should sign in successfully and return a token", async () => {
    const req = {
      body: {
        email: "user@example.com",
        password: "password123",
      },
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };

    const mockUser = {
      _id: "userId123",
      email: "user@example.com",
      password: "hashedPassword",
      _doc: { email: "user@example.com", name: "User" },
    };

    User.findOne = jest.fn().mockResolvedValue(mockUser);
    bcrypt.compare = jest.fn().mockResolvedValue(true);
    jwt.sign = jest.fn().mockReturnValue("mockedToken");

    await signIn(req, res);

    expect(User.findOne).toHaveBeenCalledWith({ email: "user@example.com" });
    expect(bcrypt.compare).toHaveBeenCalledWith("password123", "hashedPassword");
    expect(jwt.sign).toHaveBeenCalledWith({ id: "userId123" }, process.env.JWT_SECRET);
    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({
      token: "mockedToken",
      email: "user@example.com",
      name: "User",
    });
  });

  it("should return 400 if user does not exist", async () => {
    const req = {
      body: {
        email: "nonexistent@example.com",
        password: "password123",
      },
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };

    User.findOne = jest.fn().mockResolvedValue(null);

    await signIn(req, res);

    expect(User.findOne).toHaveBeenCalledWith({ email: "nonexistent@example.com" });
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      mssg: "User with this email does not exist",
    });
  });

  it("should return 400 if password is incorrect", async () => {
    const req = {
      body: {
        email: "user@example.com",
        password: "wrongPassword",
      },
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };

    const mockUser = {
      _id: "userId123",
      email: "user@example.com",
      password: "hashedPassword",
    };

    User.findOne = jest.fn().mockResolvedValue(mockUser);
    bcrypt.compare = jest.fn().mockResolvedValue(false);

    await signIn(req, res);

    expect(User.findOne).toHaveBeenCalledWith({ email: "user@example.com" });
    expect(bcrypt.compare).toHaveBeenCalledWith("wrongPassword", "hashedPassword");
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      mssg: "Incorrect password",
    });
  });

  it("should return 500 if there is an error", async () => {
    const req = {
      body: {
        email: "user@example.com",
        password: "password123",
      },
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };

    User.findOne = jest.fn().mockRejectedValue(new Error("Database error"));

    await signIn(req, res);

    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith({
      mssg: "Something went wrong",
      error: "Database error",
    });
  });
});
