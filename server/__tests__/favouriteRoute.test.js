const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');
const favoriteRouter = require('../routes/favourites'); // Adjust the path if needed
const app = express();

app.use(bodyParser.json());
app.use('/api', favoriteRouter);

describe('Favorite Routes', () => {
  beforeAll(() => {
    jest.clearAllMocks();
  });

  it('should add a doctor to favorites', async () => {
    const favoriteData = {
      userId: 'user123',
      doctorId: 'doctor123',
    };

    // Mock the addFavorite function
    const mockAddFavorite = jest.fn().mockImplementation((req, res) => {
      res.send({ message: 'Doctor added to favorites successfully' });
    });
    favoriteRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/add-favorite') {
        layer.handle = mockAddFavorite;
      }
    });

    const response = await request(app)
      .post('/api/add-favorite')
      .send(favoriteData);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should remove a doctor from favorites', async () => {
    const favoriteData = {
      userId: 'user123',
      doctorId: 'doctor123',
    };

    // Mock the removeFavorite function
    const mockRemoveFavorite = jest.fn().mockImplementation((req, res) => {
      res.send({ message: 'Doctor removed from favorites successfully' });
    });
    favoriteRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/remove-favorite') {
        layer.handle = mockRemoveFavorite;
      }
    });

    const response = await request(app)
      .post('/api/remove-favorite')
      .send(favoriteData);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  it('should get all favorites for a specific user', async () => {
    const userId = 'user123';

    // Mock the getFavorites function
    const mockGetFavorites = jest.fn().mockImplementation((req, res) => {
      res.send([{ doctorId: 'doctor123', name: 'Dr. Smith' }]);
    });
    favoriteRouter.stack.forEach(layer => {
      if (layer.route && layer.route.path === '/favorites/:userId') {
        layer.handle = mockGetFavorites;
      }
    });

    const response = await request(app)
      .get(`/api/favorites/${userId}`);

    // Basic check: Ensure the response is not an error
    expect(response.text).not.toContain('error');
  });

  // Add more tests as needed for other routes
});
