import { UserSchema, type User } from "@my-app/common";

const sampleUser: User = UserSchema.parse({
  id: crypto.randomUUID(),
  name: "Joaqim",
  email: "jq@prime.example.com",
});

function App() {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-md">
        <h1 className="text-2xl font-bold mb-4">My App</h1>
        <p className="text-gray-600">
          Hello, {sampleUser.name}! ({sampleUser.email})
        </p>
      </div>
    </div>
  );
}

export default App;
