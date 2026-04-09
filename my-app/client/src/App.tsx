import { useState, useEffect } from "react";
import type { User } from "@my-app/common";

function App() {
  const [user, setUser] = useState<User | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/user")
      .then((r) => r.json())
      .then(setUser)
      .catch((e) => setError(e.message));
  }, []);

  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-md">
        <h1 className="text-2xl font-bold mb-4">My App</h1>
        {error && (
          <p className="text-red-500">Error: {error}</p>
        )}
        {user ? (
          <p className="text-gray-600">
            Hello, {user.name}! ({user.email})
          </p>
        ) : !error ? (
          <p className="text-gray-400">Loading...</p>
        ) : null}
      </div>
    </div>
  );
}

export default App;
