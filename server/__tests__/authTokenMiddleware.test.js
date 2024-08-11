const jwt = require("jsonwebtoken");
const authMiddleware = require("../middleware/authMiddleware");

jest.mock("jsonwebtoken");

describe("Auth Middleware", () => {
  beforeEach(() => {
    jwt.verify = jest.fn();
  });

  it("should call next() if token is valid", async () => {
    const token = "validToken";
    const decoded = { id: "userId123" };

    jwt.verify.mockReturnValue(decoded);

    const req = {
      headers: {
        authorization: `Bearer ${token}`,
      },
    };
    const res = {};
    const next = jest.fn();

    await authMiddleware(req, res, next);

    expect(jwt.verify).toHaveBeenCalledWith(token, process.env.JWT_SECRET);
    expect(req.userId).toBe("userId123");
    expect(next).toHaveBeenCalled();
  });

  it("should return 401 if no token is provided", async () => {
    const req = {
      headers: {},
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };
    const next = jest.fn();

    await authMiddleware(req, res, next);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({ message: "No token, authorization denied" });
  });

  it("should return 401 if token is invalid", async () => {
    const token = "invalidToken";

    jwt.verify.mockImplementation(() => {
      throw new Error("Invalid token");
    });

    const req = {
      headers: {
        authorization: `Bearer ${token}`,
      },
    };
    const res = {
      json: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };
    const next = jest.fn();

    await authMiddleware(req, res, next);

    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({
      message: "Token is not valid",
      error: "Invalid token",
    });
  });
});
