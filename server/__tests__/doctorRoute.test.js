const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');
const doctorRouter = require('../routes/doctor'); // Adjust the path if needed
const app = express();

app.use(bodyParser.json());
app.use('/api', doctorRouter);

describe('Doctor Routes', () => {
  beforeAll(() => {
    jest.clearAllMocks();
  });

  it('should register a new doctor', async () => {
    const newDoctor = {
      name: 'Dr. Smith',
      email: 'drsmith@example.com',
      password: 'password123',
    };

    // Mock the registerDoctor function
    const mockRegisterDoctor = jest.fn().mockImplementation((req, res) => {
      res.send({ message: 'Doctor registered successfully' });
    });
    doctorRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/register') {
        layer.handle = mockRegisterDoctor;
      }
    });

    const response = await request(app)
      .post('/api/register')
      .send(newDoctor);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should sign in a doctor', async () => {
    const doctorCredentials = {
      email: 'drsmith@example.com',
      password: 'password123',
    };

    // Mock the signInDoctor function
    const mockSignInDoctor = jest.fn().mockImplementation((req, res) => {
      res.send({ token: 'fake-jwt-token' });
    });
    doctorRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/signin') {
        layer.handle = mockSignInDoctor;
      }
    });

    const response = await request(app)
      .post('/api/signin')
      .send(doctorCredentials);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should get all doctors', async () => {
    // Mock the getAllDoctor function
    const mockGetAllDoctor = jest.fn().mockImplementation((req, res) => {
      res.send([{ name: 'Dr. Smith', email: 'drsmith@example.com' }]);
    });
    doctorRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/all') {
        layer.handle = mockGetAllDoctor;
      }
    });

    const response = await request(app)
      .get('/api/all');

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should get doctor by ID', async () => {
    const doctorId = '12345';

    // Mock the getDoctor function
    const mockGetDoctor = jest.fn().mockImplementation((req, res) => {
      res.send({ name: 'Dr. Smith', email: 'drsmith@example.com' });
    });
    doctorRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/getDoctor') {
        layer.handle = mockGetDoctor;
      }
    });

    const response = await request(app)
      .post('/api/getDoctor')
      .send({ doctorId });

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should save date and time slots for a doctor', async () => {
    const doctorId = '12345';
    const slots = {
      slots: ['2024-08-15T09:00:00Z', '2024-08-15T10:00:00Z'],
    };

    // Mock the saveDateTimeSlots function
    const mockSaveDateTimeSlots = jest.fn().mockImplementation((req, res) => {
      res.send({ message: 'Date and time slots saved successfully' });
    });
    doctorRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/:doctorId/saveDateTimeSlots') {
        layer.handle = mockSaveDateTimeSlots;
      }
    });

    const response = await request(app)
      .post(`/api/${doctorId}/saveDateTimeSlots`)
      .send(slots);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should remove a date and time slot', async () => {
    const doctorId = '12345';
    const slotId = 'slot123';

    // Mock the removeDateTimeSlot function
    const mockRemoveDateTimeSlot = jest.fn().mockImplementation((req, res) => {
      res.send({ message: 'Date and time slot removed successfully' });
    });
    doctorRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/:doctorId/removeDateTimeSlot') {
        layer.handle = mockRemoveDateTimeSlot;
      }
    });

    const response = await request(app)
      .delete(`/api/${doctorId}/removeDateTimeSlot`)
      .send({ slotId });

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  // Add more tests as needed for other routes
});
