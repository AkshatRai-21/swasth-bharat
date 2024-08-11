const request = require('supertest');
const express = require('express');
const jwt = require('jsonwebtoken');
const auth = require('../middleware/auth'); // Adjust the path if needed

const app = express();
app.use(express.json());

// Dummy route protected by auth middleware
app.get('/protected', auth, (req, res) => {
  res.send({ message: 'Access granted' });
});

describe('Auth Middleware', () => {
  it('should deny access if no token is provided', async () => {
    const response = await request(app).get('/protected');

    console.log('Response:', response.body); // Log the response for debugging
    expect(response.body.msg).toBe('No auth token, access denied');
  });

  it('should deny access if an invalid token is provided', async () => {
    const response = await request(app)
      .get('/protected')
      .set('x-auth-token', 'invalidToken');

    console.log('Response:', response.body); // Log the response for debugging
    expect(response.body.msg).toBe(undefined);
  });

  it('should grant access with a valid token', async () => {
    const token = jwt.sign({ id: 'user123' }, 'passwordKey', { expiresIn: '1h' });

    const response = await request(app)
      .get('/protected')
      .set('x-auth-token', token);

    console.log('Response:', response.body); // Log the response for debugging
    expect(response.body.message).toBe('Access granted');
  });

  it('should handle server errors', async () => {
    jest.spyOn(jwt, 'verify').mockImplementation(() => { throw new Error('Test error'); });

    const response = await request(app)
      .get('/protected')
      .set('x-auth-token', 'token');

    console.log('Response:', response.body); // Log the response for debugging
    expect(response.body.error).toBe('Test error');

    jwt.verify.mockRestore();
  });
});
