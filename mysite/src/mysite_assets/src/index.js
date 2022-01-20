import { mysite } from "../../declarations/mysite";

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  // Interact with mysite actor, calling the greet method
  const greeting = await mysite.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
