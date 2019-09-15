const router = require("express").Router();

router.get("/policy",(req,res)=>{
    res.render("policy");
})
router.get("/contact",(req,res)=>{
    res.render("contact");
})

router.get("/newUser",(req,res)=>res.render("new_user"));

module.exports = router;