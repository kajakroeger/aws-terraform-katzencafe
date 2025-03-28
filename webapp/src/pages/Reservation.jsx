/*
Reservierungsformular mit API-Anbindung
*/

import { useState } from "react";

function Reservation() {
  const [formData, setFormData] = useState({ name: "", date: "", guests: 1 });
  const [message, setMessage] = useState("");

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage("Sende Reservierung...");

    try {
      const response = await fetch("https://xyz.execute-api.eu-central-1.amazonaws.com/prod/reservierung", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await response.json();
      if (response.ok) {
        setMessage("Reservierung erfolgreich gespeichert!");
      } else {
        setMessage("Fehler: " + data.error);
      }
    } catch (error) {
      setMessage("Netzwerkfehler: " + error.message);
    }
  };

  return (
    <div className="container mx-auto p-8">
      <h1 className="text-3xl font-bold mb-4">Reservierung</h1>
      <form onSubmit={handleSubmit} className="max-w-lg mx-auto bg-white p-6 rounded-lg shadow-md">
        <label className="block mb-2">Name:</label>
        <input 
          type="text" 
          name="name" 
          value={formData.name} 
          onChange={handleChange} 
          required 
          className="w-full p-2 border rounded" 
        />

        <label className="block mt-4 mb-2">Datum:</label>
        <input 
          type="date" 
          name="date" 
          value={formData.date} 
          onChange={handleChange} 
          required 
          className="w-full p-2 border rounded" 
        />

        <label className="block mt-4 mb-2">Anzahl der Gäste:</label>
        <input 
          type="number" 
          name="guests" 
          value={formData.guests} 
          onChange={handleChange} 
          min="1" 
          required 
          className="w-full p-2 border rounded" 
        />

        <button type="submit" className="w-full mt-4 bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
          Reservieren
        </button>
      </form>

      {message && <p className="mt-4 text-center text-lg font-semibold">{message}</p>}
    </div>
  );
}

export default Reservation;
