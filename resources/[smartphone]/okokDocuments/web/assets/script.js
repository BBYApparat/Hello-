// Global variables
let documentsData = [];
let selectedDocument = null;
let currentDocumentType = 'all';
let isEditing = false;

// Document types with display names
const DOCUMENT_TYPES = {
  'license': { name: 'Driving License', icon: 'fa-id-card' },
  'id': { name: 'ID Card', icon: 'fa-address-card' },
  'registration': { name: 'Vehicle Registration', icon: 'fa-car' },
  'permit': { name: 'Permit', icon: 'fa-certificate' },
  'certificate': { name: 'Certificate', icon: 'fa-award' },
  'other': { name: 'Other', icon: 'fa-file-alt' }
};

// Initialize the app
document.addEventListener("loadedPhoneFunctions", () => {
  console.log("okokDocuments: Phone functions loaded");
  loadDocuments();
});

document.addEventListener("DOMContentLoaded", () => {
  console.log("okokDocuments: DOM loaded");
  
  // Initialize if phone functions already available
  if (document.okokPhone) {
    loadDocuments();
  }
  
  // Setup event listeners
  setupEventListeners();
});

// Setup all event listeners
function setupEventListeners() {
  // Search functionality
  document.getElementById('documents-search').addEventListener('input', handleSearch);
  
  // Document type dropdown
  const dropdown = document.getElementById('document-type-dropdown');
  const dropdownMenu = document.getElementById('type-dropdown-menu');
  
  dropdown.addEventListener('click', () => {
    dropdownMenu.classList.toggle('show');
  });
  
  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target)) {
      dropdownMenu.classList.remove('show');
    }
  });
  
  // Dropdown item selection
  dropdownMenu.addEventListener('click', (e) => {
    if (e.target.classList.contains('dropdown-item')) {
      const type = e.target.dataset.type;
      const typeName = e.target.textContent;
      
      document.getElementById('selected-type').textContent = typeName;
      currentDocumentType = type;
      dropdownMenu.classList.remove('show');
      filterDocuments();
    }
  });
  
  // Add document button
  document.getElementById('add-document-btn').addEventListener('click', () => {
    openDocumentModal();
  });
  
  // Modal controls
  document.getElementById('modal-close').addEventListener('click', closeDocumentModal);
  document.getElementById('cancel-btn').addEventListener('click', closeDocumentModal);
  document.getElementById('save-btn').addEventListener('click', saveDocument);
  
  // Share modal controls
  document.getElementById('share-modal-close').addEventListener('click', closeShareModal);
  document.getElementById('share-cancel-btn').addEventListener('click', closeShareModal);
  document.getElementById('share-send-btn').addEventListener('click', sendDocument);
}

// Load documents from server
async function loadDocuments() {
  showLoading();
  
  try {
    const response = await fetchNui("getDocuments");
    if (response && response.success) {
      documentsData = response.documents || [];
      renderDocuments();
    } else {
      showError(response?.message || "Failed to load documents");
    }
  } catch (error) {
    console.error("Error loading documents:", error);
    showError("Connection error");
  }
}

// Render documents list
function renderDocuments() {
  const listContainer = document.querySelector('#documents-list');
  const loadingState = document.getElementById('loading-state');
  const emptyState = document.getElementById('empty-state');
  
  // Hide loading
  loadingState.classList.add('hidden');
  
  // Filter documents
  let filteredDocs = documentsData;
  if (currentDocumentType !== 'all') {
    filteredDocs = documentsData.filter(doc => doc.type === currentDocumentType);
  }
  
  // Apply search filter
  const searchTerm = document.getElementById('documents-search').value.toLowerCase();
  if (searchTerm) {
    filteredDocs = filteredDocs.filter(doc => 
      doc.title.toLowerCase().includes(searchTerm) ||
      doc.content.toLowerCase().includes(searchTerm)
    );
  }
  
  // Show empty state if no documents
  if (filteredDocs.length === 0) {
    listContainer.innerHTML = '';
    emptyState.classList.remove('hidden');
    return;
  }
  
  emptyState.classList.add('hidden');
  
  // Render documents
  listContainer.innerHTML = filteredDocs.map(doc => createDocumentHTML(doc)).join('');
  
  // Add click listeners to documents
  document.querySelectorAll('.document-item').forEach(item => {
    item.addEventListener('click', (e) => {
      if (!e.target.closest('.document-actions')) {
        selectDocument(parseInt(item.dataset.id));
      }
    });
  });
  
  // Add action button listeners
  document.querySelectorAll('.action-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const action = btn.dataset.action;
      const docId = parseInt(btn.closest('.document-item').dataset.id);
      handleDocumentAction(action, docId);
    });
  });
}

// Create HTML for a single document
function createDocumentHTML(doc) {
  const typeInfo = DOCUMENT_TYPES[doc.type] || DOCUMENT_TYPES['other'];
  const date = new Date(doc.lastupdate || doc.created_at).toLocaleDateString();
  
  return `
    <div class="document-item ${selectedDocument?.id === doc.id ? 'selected' : ''}" data-id="${doc.id}">
      <div class="document-title">
        <i class="fas ${typeInfo.icon} text-emerald-400"></i>
        <span class="text-white">${doc.title}</span>
        <span class="document-type-badge">${typeInfo.name}</span>
      </div>
      <div class="document-content">${doc.content.substring(0, 100)}${doc.content.length > 100 ? '...' : ''}</div>
      <div class="document-date">Last modified: ${date}</div>
      <div class="document-actions">
        <button class="action-btn share-local" data-action="share-local" title="Share Locally">
          <i class="fas fa-share-alt"></i>
        </button>
        <button class="action-btn share-perm" data-action="share-permanent" title="Share Permanently">
          <i class="fas fa-share"></i>
        </button>
        <button class="action-btn save" data-action="edit" title="Edit">
          <i class="fas fa-edit"></i>
        </button>
        <button class="action-btn delete" data-action="delete" title="Delete">
          <i class="fas fa-trash"></i>
        </button>
      </div>
    </div>
  `;
}

// Select a document
function selectDocument(docId) {
  // Deselect previous
  document.querySelectorAll('.document-item').forEach(item => {
    item.classList.remove('selected');
  });
  
  // Select new document
  selectedDocument = documentsData.find(doc => doc.id === docId);
  if (selectedDocument) {
    const item = document.querySelector(`[data-id="${docId}"]`);
    if (item) {
      item.classList.add('selected');
    }
  }
}

// Handle document actions
async function handleDocumentAction(action, docId) {
  const doc = documentsData.find(d => d.id === docId);
  if (!doc) return;
  
  selectedDocument = doc;
  
  switch (action) {
    case 'share-local':
      await shareDocumentLocally(doc);
      break;
    case 'share-permanent':
      openShareModal(doc);
      break;
    case 'edit':
      openDocumentModal(doc);
      break;
    case 'delete':
      await deleteDocument(doc);
      break;
  }
}

// Open document modal for create/edit
function openDocumentModal(doc = null) {
  const modal = document.getElementById('document-modal');
  const modalTitle = document.getElementById('modal-title');
  const titleInput = document.getElementById('document-title');
  const typeSelect = document.getElementById('document-type');
  const contentTextarea = document.getElementById('document-content');
  
  isEditing = !!doc;
  
  if (isEditing) {
    modalTitle.textContent = 'Edit Document';
    titleInput.value = doc.title;
    typeSelect.value = doc.type;
    contentTextarea.value = doc.content;
  } else {
    modalTitle.textContent = 'New Document';
    titleInput.value = '';
    typeSelect.value = 'other';
    contentTextarea.value = '';
  }
  
  modal.classList.add('active');
  titleInput.focus();
}

// Close document modal
function closeDocumentModal() {
  document.getElementById('document-modal').classList.remove('active');
  isEditing = false;
  selectedDocument = null;
}

// Save document
async function saveDocument() {
  const title = document.getElementById('document-title').value.trim();
  const type = document.getElementById('document-type').value;
  const content = document.getElementById('document-content').value.trim();
  
  if (!title) {
    notifyIsland({
      title: "Documents",
      text: "Please enter a document title",
      duration: 3000
    });
    return;
  }
  
  if (!content) {
    notifyIsland({
      title: "Documents",
      text: "Please enter document content",
      duration: 3000
    });
    return;
  }
  
  const documentData = {
    title: title,
    type: type,
    content: content,
    time: new Date().toISOString()
  };
  
  try {
    let response;
    if (isEditing && selectedDocument) {
      documentData.id = selectedDocument.id;
      documentData.action = 'update';
      response = await fetchNui("saveDocument", documentData);
    } else {
      documentData.action = 'new';
      response = await fetchNui("saveDocument", documentData);
    }
    
    if (response && response.success) {
      notifyIsland({
        title: "Documents",
        text: isEditing ? "Document updated" : "Document created",
        duration: 2000
      });
      closeDocumentModal();
      loadDocuments(); // Refresh the list
    } else {
      notifyIsland({
        title: "Documents",
        text: response?.message || "Failed to save document",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error saving document:", error);
    notifyIsland({
      title: "Documents",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Delete document
async function deleteDocument(doc) {
  try {
    const response = await fetchNui("deleteDocument", { id: doc.id });
    
    if (response && response.success) {
      notifyIsland({
        title: "Documents",
        text: "Document deleted",
        duration: 2000
      });
      loadDocuments(); // Refresh the list
    } else {
      notifyIsland({
        title: "Documents",
        text: response?.message || "Failed to delete document",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error deleting document:", error);
    notifyIsland({
      title: "Documents",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Share document locally (to nearby players)
async function shareDocumentLocally(doc) {
  try {
    const response = await fetchNui("shareDocumentLocal", { 
      title: doc.title,
      content: doc.content,
      type: doc.type
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Documents",
        text: "Document shared locally",
        duration: 2000
      });
    } else {
      notifyIsland({
        title: "Documents",
        text: response?.message || "Failed to share document",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error sharing document locally:", error);
    notifyIsland({
      title: "Documents",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Open share modal
function openShareModal(doc) {
  selectedDocument = doc;
  document.getElementById('recipient-state-id').value = '';
  document.getElementById('share-modal').classList.add('active');
  document.getElementById('recipient-state-id').focus();
}

// Close share modal
function closeShareModal() {
  document.getElementById('share-modal').classList.remove('active');
  selectedDocument = null;
}

// Send document permanently
async function sendDocument() {
  const stateId = document.getElementById('recipient-state-id').value.trim();
  
  if (!stateId) {
    notifyIsland({
      title: "Documents",
      text: "Please enter recipient's State ID",
      duration: 3000
    });
    return;
  }
  
  if (!selectedDocument) return;
  
  try {
    const response = await fetchNui("shareDocumentPermanent", {
      stateId: stateId,
      title: selectedDocument.title,
      content: selectedDocument.content,
      type: selectedDocument.type
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Documents",
        text: "Document sent successfully",
        duration: 2000
      });
      closeShareModal();
    } else {
      notifyIsland({
        title: "Documents",
        text: response?.message || "Failed to send document",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error sending document:", error);
    notifyIsland({
      title: "Documents",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Handle search
function handleSearch() {
  filterDocuments();
}

// Filter documents
function filterDocuments() {
  renderDocuments();
}

// Show loading state
function showLoading() {
  document.getElementById('loading-state').classList.remove('hidden');
  document.getElementById('empty-state').classList.add('hidden');
  document.querySelector('#documents-list').innerHTML = '';
}

// Show error
function showError(message) {
  document.getElementById('loading-state').classList.add('hidden');
  document.getElementById('empty-state').classList.add('hidden');
  
  notifyIsland({
    title: "Documents",
    text: message,
    duration: 3000
  });
}

// Handle Dark Mode Toggle
document.addEventListener("darkMode", (e) => {
  const isDark = e.detail;
  console.log(`okokDocuments: Dark Mode ${isDark ? 'enabled' : 'disabled'}`);
});

// Handle received documents from other players
document.addEventListener("documentReceived", (e) => {
  const documentData = e.detail;
  
  notifyIsland({
    title: "Documents",
    text: `New document received: ${documentData.title}`,
    duration: 3000
  });
  
  // Refresh documents list to include the new one
  loadDocuments();
});