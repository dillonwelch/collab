// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"

// See https://phuoc.ng/collection/html-dom/swap-two-nodes/
const swap = function (nodeA, nodeB) {
    const parentA = nodeA.parentNode;
    const siblingA = nodeA.nextSibling === nodeB ? nodeA : nodeA.nextSibling;

    // Move `nodeA` to before the `nodeB`
    nodeB.parentNode.insertBefore(nodeA, nodeB);

    // Move `nodeB` to before the sibling of `nodeA`
    parentA.insertBefore(nodeB, siblingA);
};

window.onload = function () {
    document.querySelectorAll(".playlist-draggable").forEach(node => {
        node.addEventListener(
            "dragstart", (event) => {
                event.dataTransfer.setData("text/plain", event.target.id)
                event.dataTransfer.effectAllowed = "move";
            }
        );
        node.addEventListener(
            "dragover", (event) => {
                event.dataTransfer.dropEffect = "move";
                event.preventDefault();
            }
        );
        node.addEventListener(
            "drop", (event) => {
                event.preventDefault();
                const dragId = event.dataTransfer.getData("text");
                const dragParentNode = document.getElementById(dragId).parentNode;
                const dropId = event.target.id;
                const dropParentNode = event.target.parentNode;
                swap(dragParentNode, dropParentNode);

                const apiUrl = '/playlist_videos/swap';
                const data = {
                    from_id: dragId.replace("draggable-", ''),
                    to_id: dropId.replace("draggable-", ''),
                };

                const requestOptions = {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data),
                };

                fetch(apiUrl, requestOptions).then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                }).catch(error => {
                    console.error('Error:', error);
                });
            }
        );
    });
};

