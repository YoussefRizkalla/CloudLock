const router = require("express").Router();
var admin = require("firebase-admin");

var serviceAccount = require("../credentials.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://cloudlock-ca508.firebaseio.com"
});

let db = admin.firestore();

module.exports = router.get("/",(req,res)=>{
    let users = []
    db.collection("faceId").get().then((data)=>{
        data.forEach(data=>users.push(data.data()));
        res.render("home",{users:users});
    }).catch()
})