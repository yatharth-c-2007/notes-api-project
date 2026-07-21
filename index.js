const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

let notes = [];
let nextId = 1;

app.get('/notes', (req, res) => {
  res.json(notes);
});

app.post('/notes', (req, res) => {
  const note = { id: nextId++, text: req.body.text };
  notes.push(note);
  res.status(201).json(note);
});

app.get('/notes/:id', (req, res) => {
  const note = notes.find(n => n.id === parseInt(req.params.id));
  if (!note) return res.status(404).json({ error: 'Note not found' });
  res.json(note);
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
