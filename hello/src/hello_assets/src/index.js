import { hello, createActor } from "../../declarations/hello";

var currentUser = "";
var intervals = [];
async function post() {
  document.getElementById("error").innerText = "";
  let post_button = document.getElementById('post');
  let otp = document.getElementById('otp').value;
  post_button.disabled = true;
  let textarea = document.getElementById("text");
  let text = textarea.value;
  if (text == "") {
    alert("内容不能为空")
  }
  try {
    await hello.post(otp, text)
  } catch (err) {
    document.getElementById("error").innerText = "Post failed"
  }

  post_button.disabled = false;

}

async function load_posts(currentUser) {
  toggleLoading()
  if (currentUser) {
    let username = currentUser.split("@")[0];
    let principal = currentUser.split("@")[1];
    let canister = createActor(principal)
    let posts = await canister.posts();
    // let name = await canister.get_name();
    if (username) {
      posts.forEach(element => {
        element.author = username;
      });
    }

    renderBlog(posts)
  } else {

    let posts = await hello.timeline();
    renderBlog(posts)

  }
  toggleLoading()


}
function renderBlog(posts) {
  let posts_section = document.getElementById('posts')
  // if (num_posts==posts.length) return;
  posts_section.replaceChildren([]);

  for (var i = 0; i < posts.length; i++) {
    let post = document.createElement("div");
    post.innerHTML = "<p>" + posts[i].content + "</p> </br> <span id='author'>    发布时间:" + convertTime(Number(posts[i].time)) + "&nbsp;&nbsp;&nbsp;&nbsp;作者：" + posts[i].author + "</span>";
    posts_section.appendChild(post)
  }

  // num_posts = posts.length;
}
function convertTime(timestamp) {
  let date = new Date(Math.round(timestamp / 1000000));
  let datestr = date.getFullYear() + '/' + date.getMonth() + 1 + '/' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
  return datestr
}

async function getFollows() {
  var followList = []
  followList = await hello.follows();
  for (var i = 0; i < followList.length; i++) {
    let canister = createActor(followList[i])
    let name = await canister.get_name()
    let li = document.createElement("li");
    li.className = "followee"
    li.innerText = name + "(" + followList[i] + ")";
    li.onclick = (e) => { nameClick(e) }
    li.dataset.principal = name + '@' + followList[i]
    document.getElementById("follow-list").appendChild(li)
  }
}

function nameClick(e) {

  let principal = e.target.dataset.principal;
  currentUser = principal
  load_posts(currentUser)

}

function toggleLoading() {

  var loader = document.getElementById("modal")

  if (loader.style.display == "none") {
    loader.style.display = "block"
  } else {
    loader.style.display = "none"
  }
}

function load() {
  let post_button = document.getElementById('post');
  post_button.onclick = post;
  // load_posts(currentUser)
  load_posts(currentUser)
  getFollows();
}



let queryAll = document.getElementById('query-all');
queryAll.addEventListener('click', e => {

  currentUser = ""
  load_posts(currentUser)

});



window.onload = load;