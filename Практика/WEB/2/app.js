"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const bodyParser = require("body-parser");
const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.get("/", function (req, res) {
    console.log("Okay");
    res.send("Lol");
});
app.use((req, res, next) => {
    console.log(req.url);
    next();
});
app.get("/ki", function (req, res) {
    return res.status(400).send({
        message: "keklol"
    });
});
app.get("/user/:userID", (req, res) => {
    res.send(req.params.userID);
});
app.post("/body", (req, res) => {
    res.send(req.body);
});
app.get("/user", (req, res) => {
    res.send(req.headers.host);
});
app.listen(8000, () => console.log("Server has started"));
