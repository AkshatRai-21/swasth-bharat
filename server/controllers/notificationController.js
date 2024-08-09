const Notification = require("../models/notification");
const addNotificationJob = require("../scheduler.js");

// Add a new notification
exports.addNotification = async (req, res) => {const { userId, msg } = req.body;
  try {
    const notification = new Notification({
      user_id: userId,
      msg: msg,
      seen: false,
    });

    await notification.save();
    res
      .status(200)
      .json({ message: "Notification added and pushed successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to add notification" });
  }};

// Schedule a notification
exports.scheduleNotification = async (req, res) => {
   const { userId, msg, delayInMinutes = 0 } = req.body;

  try {
    await addNotificationJob(userId, msg, delayInMinutes);
    res.status(200).json({ message: "Notification passed for verification" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Failed to schedule notification" });
  }
};

// Update notification status
exports.updateNotificationStatus = async (req, res) => {
  const { userId, notificationId } = req.body;
  try {
    const notification = await Notification.findOne({
      user_id: userId,
      _id: notificationId,
    });
    if (!notification) {
      return res.status(404).json({ error: "Notification not found" });
    }
    notification.seen = true;
    await notification.save();
    res.status(200).json({ message: "Notification status updated" });
  } catch (error) {
    res.status(500).json({ error: "Failed to update notification status" });
  }
};

// Get all notifications for a user
exports.getUserNotifications = async (req, res) => {
  const { userId } = req.params;
  try {
    const notifications = await Notification.find({ user_id: userId }).sort({
      timestamp: -1,
    });
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch notifications" });
  }
};

// Delete a notification
exports.deleteNotification = async (req, res) => {
  const { notificationId } = req.params;
  try {
    const result = await Notification.deleteOne({ _id: notificationId });
    if (result.deletedCount === 0) {
      return res.status(404).json({ error: "Notification not found" });
    }
    res.status(200).json({ message: "Notification deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete notification" });
  }
};
