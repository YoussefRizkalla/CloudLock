const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const main = require("./routes/main")
const firebaseRouter = require("./routes/firebase");
const idRouter = require("./routes/faceid");
const graphRouter = require("./routes/graph");
const analyticsRouter = require("./routes/analytics");
const other = require("./routes/extra");

app.set("view engine","ejs");
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());
app.use(express.static(`${__dirname}/publc`));

app.use(main);
app.use(firebaseRouter);
app.use(idRouter);
app.use(graphRouter);
app.use(analyticsRouter);
app.use(other);

app.listen(3000,()=>console.log("Running"));

module.exports = app;