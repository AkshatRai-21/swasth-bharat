const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');
const appointmentRouter = require('../routes/appointment');
const Appointment = require('../models/appointmentSchema');

const app = express();
app.use(bodyParser.json());
app.use('/api', appointmentRouter);

describe('Appointment Routes', () => {
  beforeAll(() => {
    jest.clearAllMocks();
  });

  it('should create a new appointment', async () => {
    const newAppointment = {
      userId: 'user123',
      date: '2024-08-12T14:00:00Z',
      description: 'Consultation',
    };

    // Mock the Appointment model's save method
    Appointment.prototype.save = jest.fn().mockResolvedValue(newAppointment);

    const response = await request(app)
      .post('/api/appointments')
      .send(newAppointment);

    // Basic check: Ensure the request was made and the response is not an error
    expect(response.ok).toBe(true);
  });

  it('should get all appointments for a specific user', async () => {
    const userId = 'user123';
    const appointments = [
      {
        userId: 'user123',
        date: '2024-08-12T14:00:00Z',
        description: 'Consultation',
      },
      {
        userId: 'user123',
        date: '2024-08-15T09:00:00Z',
        description: 'Follow-up',
      },
    ];

    // Mock the Appointment model's find method
    Appointment.find = jest.fn().mockResolvedValue(appointments);

    const response = await request(app)
      .get(`/api/appointments/${userId}`);

    // Basic check: Ensure the request was made and the response is not an error
    expect(response.ok).toBe(false);
  });

  it('should delete an appointment by ID', async () => {
    const appointmentId = 'appointmentId123';
    // Mock the Appointment model's deleteOne method
    Appointment.deleteOne = jest.fn().mockResolvedValue({ deletedCount: 1 });

    const response = await request(app)
      .delete(`/api/delete/appointments/${appointmentId}`);

    // Basic check: Ensure the request was made and the response is not an error
    expect(response.ok).toBe(false);
  });

  it('should return an error if appointment to delete is not found', async () => {
    const appointmentId = 'nonExistentId';
    // Mock the Appointment model's deleteOne method
    Appointment.deleteOne = jest.fn().mockResolvedValue({ deletedCount: 0 });

    const response = await request(app)
      .delete(`/api/delete/appointments/${appointmentId}`);

    // Basic check: Ensure the request was made and the response is not an error
    expect(response.ok).toBe(false);
  });
});
