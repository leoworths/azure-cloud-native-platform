import { useEffect, useState } from "react";
import axios from "axios";

const API_URL = "/api/tasks/"; // "http://localhost:8000/api/tasks/";

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");

  const fetchTasks = async () => {
    try {
      const response = await axios.get(API_URL);
      setTasks(response.data);
    } catch (error) {
      console.error("Error fetching tasks:", error);
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  const addTask = async (e) => {
    e.preventDefault();
    if (!title.trim()) return;

    try {
      await axios.post(API_URL, { title, completed: false });
      setTitle("");
      fetchTasks();
    } catch (error) {
      console.error("Error adding task:", error);
    }
  };

  const toggleTask = async (task) => {
    try {
      await axios.put(`${API_URL}${task.id}/`, {
        title: task.title,
        completed: !task.completed,
      });
      fetchTasks();
    } catch (error) {
      console.error("Error updating task:", error);
    }
  };

  const deleteTask = async (id) => {
    try {
      await axios.delete(`${API_URL}${id}/`);
      fetchTasks();
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  };

  return (
    <div style={{ maxWidth: "600px", margin: "40px auto", fontFamily: "Arial" }}>
      <h1>To Do App</h1>

      <form onSubmit={addTask} style={{ display: "flex", gap: "10px", marginBottom: "20px" }}>
        <input
          type="text"
          placeholder="Enter a task"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          style={{ flex: 1, padding: "10px" }}
        />
        <button type="submit">Add</button>
      </form>

      {tasks.map((task) => (
        <div
          key={task.id}
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            padding: "10px",
            border: "1px solid #ddd",
            marginBottom: "10px",
          }}
        >
          <span
            onClick={() => toggleTask(task)}
            style={{
              cursor: "pointer",
              textDecoration: task.completed ? "line-through" : "none",
            }}
          >
            {task.title}
          </span>

          <button onClick={() => deleteTask(task.id)}>Delete</button>
        </div>
      ))}
    </div>
  );
}

export default App;