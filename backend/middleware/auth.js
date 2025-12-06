const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
    // Get token from header
    const token = req.header('Authorization')?.split(' ')[1];

    // Check if not token
    if (!token) {
        return res.status(401).json({ message: 'No token, authorization denied' });
    }

    // Verify token
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');

        // Transform to match previous structure if needed, or update routes
        // Previous structure: req.user = { uid: ..., email: ... }
        // New structure: req.user = { id: ..., isAdmin: ... }

        // To maintain compatibility with existing routes that expect req.user.uid:
        req.user = {
            id: decoded.user.id,
            uid: decoded.user.id, // Map Mongo ID to uid for compatibility
            isAdmin: decoded.user.isAdmin
        };

        next();
    } catch (err) {
        res.status(401).json({ message: 'Token is not valid' });
    }
};

module.exports = verifyToken;
