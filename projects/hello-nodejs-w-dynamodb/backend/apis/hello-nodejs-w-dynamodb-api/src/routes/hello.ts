import express, { Router, Request, Response, NextFunction } from "express";

const router: Router = express.Router();

router.get("/", (req: Request, res: Response) => {
  res.json({
    method: req.method,
    message: "Hello, world!",
  });
});

router.post("/", (req: Request, res: Response) => {
  const { name } = req.body;
  res.json({
    method: req.method,
    message: `Hello, ${name}!`,
  });
});

router.put("/:id", (req: Request, res: Response) => {
  const id = req.params.id;
  const { name } = req.body;
  res.json({
    method: req.method,
    message: `Hello, ${name}!`,
    id: id,
  });
});

router.patch("/:id", (req: Request, res: Response) => {
  const id = req.params.id;
  const { name } = req.body;
  res.json({
    method: req.method,
    message: `Hello, ${name}!`,
    id: id,
  });
});

router.delete("/:id", (req: Request, res: Response) => {
  const id = req.params.id;
  res.json({
    method: req.method,
    id: id,
  });
});

export default router;
