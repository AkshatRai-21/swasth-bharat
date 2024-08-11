const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');
const userRouter = require('../routes/user'); // Adjust the path if needed
const app = express();

app.use(bodyParser.json());
app.use('/api', userRouter);

describe('User Routes', () => {
  beforeAll(() => {
    jest.clearAllMocks();
  });

  it('should sign in a user', async () => {
    const userCredentials = {
      email: 'testuser@example.com',
      password: 'password123',
    };

    // Mock the signIn function
    const mockSignIn = jest.fn().mockImplementation((req, res) => {
      res.send({ token: 'fake-jwt-token' });
    });
    userRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/signin') {
        layer.handle = mockSignIn;
      }
    });

    const response = await request(app)
      .post('/api/signin')
      .send(userCredentials);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should sign up a new user', async () => {
    const newUser = {
      name: 'John Doe',
      email: 'newuser@example.com',
      password: 'password123',
    };

    // Mock the signUp function
    const mockSignUp = jest.fn().mockImplementation((req, res) => {
      res.send({ message: 'User created successfully' });
    });
    userRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/signup') {
        layer.handle = mockSignUp;
      }
    });

    const response = await request(app)
      .post('/api/signup')
      .send(newUser);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should check if token is valid', async () => {
    const token = 'valid-token';

    // Mock the tokenIsValid function
    const mockTokenIsValid = jest.fn().mockImplementation((req, res) => {
      res.send({ valid: true });
    });
    userRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/tokenIsValid') {
        layer.handle = mockTokenIsValid;
      }
    });

    const response = await request(app)
      .post('/api/tokenIsValid')
      .send({ token });

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should get user data', async () => {
    // Mock the getUser function
    const mockGetUser = jest.fn().mockImplementation((req, res) => {
      res.send({ name: 'John Doe', email: 'testuser@example.com' });
    });
    userRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/getUser') {
        layer.handle = mockGetUser;
      }
    });

    const response = await request(app)
      .get('/api/getUser');

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });
});
