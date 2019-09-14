const express = require("express");
const app = express();
const bodyParser = require("body-parser");

app.set("view engine","ejs");
app.use(bodyParser.urlencoded({extended:true}));
app.use(express.static(`${__dirname}/publc`));


app.get("/",(req,res)=>{
    res.render("home");
})

app.listen(3000,()=>console.log("Running"));

module.exports = app;