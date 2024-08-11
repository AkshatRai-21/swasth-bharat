const mongoose = require('mongoose');
const Appointment = require('../models/appointmentSchema');
const { createAppointment, getUserAppointments, deleteAppointment } = require('../controllers/appointmentController');

// Mock the Appointment model
jest.mock('../models/appointmentSchema');

describe('Appointment Controller', () => {

  afterEach(() => {
    jest.clearAllMocks();
  });


  describe('getUserAppointments', () => {
    it('should fetch all appointments for a specific user', async () => {
      const req = { params: { userId: 'user123' } };
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      };

      Appointment.find = jest.fn().mockReturnValue({
        populate: jest.fn().mockResolvedValue([{ doctorId: 'doctor123', userId: 'user123' }])
      });

      await getUserAppointments(req, res);

      expect(Appointment.find).toHaveBeenCalledWith({ userId: 'user123' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith([{ doctorId: 'doctor123', userId: 'user123' }]);
    });

    it('should return a 500 error if fetching appointments fails', async () => {
      const req = { params: { userId: 'user123' } };
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      };

      Appointment.find = jest.fn().mockReturnValue({
        populate: jest.fn().mockRejectedValue(new Error('Failed to fetch'))
      });

      await getUserAppointments(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: 'Failed to fetch appointments' });
    });
  });

  describe('deleteAppointment', () => {
    it('should delete an appointment by ID and return success', async () => {
      const req = { params: { id: 'appointment123' } };
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      };

      Appointment.findByIdAndDelete = jest.fn().mockResolvedValue(true);

      await deleteAppointment(req, res);

      expect(Appointment.findByIdAndDelete).toHaveBeenCalledWith('appointment123');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith({ message: 'Appointment deleted successfully' });
    });

    it('should return a 404 error if the appointment is not found', async () => {
      const req = { params: { id: 'appointment123' } };
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      };

      Appointment.findByIdAndDelete = jest.fn().mockResolvedValue(false);

      await deleteAppointment(req, res);

      expect(Appointment.findByIdAndDelete).toHaveBeenCalledWith('appointment123');
      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith({ error: 'Appointment not found' });
    });

    it('should return a 500 error if deletion fails', async () => {
      const req = { params: { id: 'appointment123' } };
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      };

      Appointment.findByIdAndDelete = jest.fn().mockRejectedValue(new Error('Failed to delete'));

      await deleteAppointment(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: 'Failed to delete appointment' });
    });
  });

});
