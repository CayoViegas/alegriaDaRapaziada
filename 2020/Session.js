const User = require("../models/User");
const jwt = require("jsonwebtoken");
const { secret } = require("../config/vars");

module.exports = {
  async login(req, res) {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user) return res.status(404).send({ error: "User not found" });
    if (password != user.password)
      return res.status(400).send({ error: "Invalid password" });
    if (!user.active === 1) {
      return res.status(401).send({ error: "Email has not been confirmed" });
    }

    user.password = undefined;

    const token = jwt.sign({ id: user._id }, secret, {
      expiresIn: 86400,
    });

    res.send({ user, token });
  },

  async auth(req, res, next) {
    const header = req.headers.authorization;
    if (!header) return res.status(401).send({ error: "No token provided" });

    const parts = header.split(" ");

    if (!parts.length === 2) {
      return res.status(401).send({ error: "Token error" });
    }

    const [scheme, token] = parts;

    if (!/^Bearer$/i.test(scheme))
      return res.status(401).send({ error: "Token malformatted" });

    jwt.verify(token, secret, function (err, decoded) {
      if (err) return res.status(401).send({ error: "Token invalid" });

      req.userId = decoded.id;
      console.log(req.userId);
      return next();
    });
  },
};
