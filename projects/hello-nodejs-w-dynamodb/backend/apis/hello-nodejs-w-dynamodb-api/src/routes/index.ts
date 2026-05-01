import express, { Router } from "express";
import helloRouter from "./hello";
import notesRouter from "./notes";
import userRouter from "./user";

const router: Router = express.Router();

router.use("/hello", helloRouter);
router.use("/notes", notesRouter);
router.use("/user", userRouter);

export default router;
