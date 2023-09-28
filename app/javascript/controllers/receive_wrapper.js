const receivedFromWorld = (textContent) => {
  const html = document.createElement("p");
  html.textContent = "Lobby: " + textContent;
  return html;
};

const receivedFromUser = ({ message: textContent, uuid: user, nickname }) => {
  const html = document.createElement("p");

  html.textContent =
    (nickname ? `${nickname}(${user})` : user) + ": " + textContent;
  return html;
};

export { receivedFromUser, receivedFromWorld };
