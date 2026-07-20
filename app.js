const FIREBASE_URL = 'https://catalogo-25a73-default-rtdb.firebaseio.com';
const LS_CART_KEY  = 'cc_carrito';
const LS_NAME_KEY  = 'cc_cliente_nombre';
const CATEGORY_DISPLAY = {
    'Licores':     'Licores',
    'Protectores': 'Protectores',
    'Bebidas':     'Bebidas',
    'Snacks':      'Snacks',
    'Higiene':     'Higiene',
    'Accesorios':  'Accesorios',
    'Souvenirs':   'Souvenirs',
};
const CATEGORY_ORDER = [
    'Todos', 'Snacks', 'Bebidas', 'Protectores',
    'Licores', 'Higiene', 'Accesorios', 'Souvenirs'
];
const State = {
    productos:            {},
    carrito:              [],
    tasaBcv:              0,
    tiendaAbierta:        true,
    clienteNombre:        '',
    categoriaActiva:      'Todos',
    productoSeleccionado: null,
    cantidadSeleccionada: 1,
    monedaActiva:         'USD',
    idiomaActivo:         'es',
    diccionarioTraducciones: {},
};

const I18N = {
    es: {
        hello: 'Hola,', search: 'Buscar', my_cart: 'MI CARRITO', total: 'TOTAL',
        confirm_order_btn: 'CONFIRMAR PEDIDO', summary: 'RESUMEN', your_name: 'TU NOMBRE',
        name_instruction: 'Ingresa tu nombre para identificar tu pedido al retirar.',
        create_order: 'CREAR PEDIDO', my_orders: 'MIS PEDIDOS', no_orders: 'No tienes pedidos aún',
        start_shopping: 'Comenzar a Comprar', cart_empty: 'Tu carrito está vacío',
        explore: 'Explorar Catálogo', back: 'Volver', category_label: 'CATEGORÍA',
        price_ref: 'PRECIO REF.', stock_label: 'STOCK DISPONIBLE:', confirm_order: 'CONFIRMAR PEDIDO',
        show_all: 'Mostrar todos los'
    },
    en: {
        hello: 'Hello,', search: 'Search', my_cart: 'MY CART', total: 'TOTAL',
        confirm_order_btn: 'CONFIRM ORDER', summary: 'SUMMARY', your_name: 'YOUR NAME',
        name_instruction: 'Enter your name to identify your order at pickup.',
        create_order: 'CREATE ORDER', my_orders: 'MY ORDERS', no_orders: 'You have no orders yet',
        start_shopping: 'Start Shopping', cart_empty: 'Your cart is empty',
        explore: 'Explore Catalog', back: 'Back', category_label: 'CATEGORY',
        price_ref: 'REF PRICE', stock_label: 'AVAILABLE STOCK:', confirm_order: 'CONFIRM ORDER',
        show_all: 'Show all'
    },
    pt: {
        hello: 'Olá,', search: 'Buscar', my_cart: 'MEU CARRINHO', total: 'TOTAL',
        confirm_order_btn: 'CONFIRMAR PEDIDO', summary: 'RESUMO', your_name: 'SEU NOME',
        name_instruction: 'Digite seu nome para identificar seu pedido na retirada.',
        create_order: 'CRIAR PEDIDO', my_orders: 'MEUS PEDIDOS', no_orders: 'Você ainda não tem pedidos',
        start_shopping: 'Começar a Comprar', cart_empty: 'Seu carrinho está vazio',
        explore: 'Explorar Catálogo', back: 'Voltar', category_label: 'CATEGORIA',
        price_ref: 'PREÇO REF.', stock_label: 'ESTOQUE DISPONÍVEL:', confirm_order: 'CONFIRMAR PEDIDO',
        show_all: 'Mostrar todos os'
    },
    de: {
        hello: 'Hallo,', search: 'Suchen', my_cart: 'MEIN WARENKORB', total: 'GESAMT',
        confirm_order_btn: 'BESTELLUNG BESTÄTIGEN', summary: 'ZUSAMMENFASSUNG', your_name: 'DEIN NAME',
        name_instruction: 'Geben Sie Ihren Namen ein, um Ihre Bestellung bei der Abholung zu identifizieren.',
        create_order: 'BESTELLUNG AUFGEBEN', my_orders: 'MEINE BESTELLUNGEN', no_orders: 'Sie haben noch keine Bestellungen',
        start_shopping: 'Mit dem Einkaufen beginnen', cart_empty: 'Ihr Warenkorb ist leer',
        explore: 'Katalog durchsuchen', back: 'Zurück', category_label: 'KATEGORIE',
        price_ref: 'REF PREIS', stock_label: 'VERFÜGBARER BESTAND:', confirm_order: 'BESTELLUNG BESTÄTIGEN',
        show_all: 'Alle anzeigen'
    }
};

const CATEGORY_DISPLAY_EN = {
    'Licores': 'Liquor', 'Protectores': 'Sunscreen', 'Bebidas': 'Drinks',
    'Snacks': 'Snacks', 'Higiene': 'Hygiene', 'Accesorios': 'Accessories',
    'Souvenirs': 'Souvenirs', 'Todos': 'All'
};
const CATEGORY_DISPLAY_PT = {
    'Licores': 'Licores', 'Protectores': 'Protetores', 'Bebidas': 'Bebidas',
    'Snacks': 'Petiscos', 'Higiene': 'Higiene', 'Accesorios': 'Acessórios',
    'Souvenirs': 'Lembranças', 'Todos': 'Todos'
};
const CATEGORY_DISPLAY_DE = {
    'Licores': 'Spirituosen', 'Protectores': 'Sonnencreme', 'Bebidas': 'Getränke',
    'Snacks': 'Snacks', 'Higiene': 'Hygiene', 'Accesorios': 'Zubehör',
    'Souvenirs': 'Souvenirs', 'Todos': 'Alle'
};
const $ = (id) => document.getElementById(id);
const $$ = (sel) => document.querySelectorAll(sel);
const Firebase = {
    async get(path) {
        const res = await fetch(`${FIREBASE_URL}/${path}.json`);
        if (!res.ok) throw new Error(`GET ${path} → ${res.status}`);
        return res.json();
    },
    async put(path, data) {
        const res = await fetch(`${FIREBASE_URL}/${path}.json`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        });
        if (!res.ok) throw new Error(`PUT ${path} → ${res.status}`);
        return res.json();
    },
};
function saveCart() {
    try { localStorage.setItem(LS_CART_KEY, JSON.stringify(State.carrito)); }
    catch(e) { console.warn('localStorage save failed', e); }
}
function loadCart() {
    try {
        const raw = localStorage.getItem(LS_CART_KEY);
        if (raw) State.carrito = JSON.parse(raw);
    } catch(e) { State.carrito = []; }
}
function saveClientName(name) {
    State.clienteNombre = name.trim();
    try { localStorage.setItem(LS_NAME_KEY, State.clienteNombre); }
    catch(e) {  }
}
function loadClientName() {
    try { State.clienteNombre = localStorage.getItem(LS_NAME_KEY) || ''; }
    catch(e) { State.clienteNombre = ''; }
}
function showToast(message, type = 'info', duration = 3000) {
    const container = $('toast-container');
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    const icons = { success: '✓', error: '✕', warning: '⚠', info: 'ℹ' };
    toast.innerHTML = `<strong>${icons[type] || 'ℹ'}</strong> ${message}`;
    container.appendChild(toast);
    setTimeout(() => {
        toast.classList.add('toast-out');
        toast.addEventListener('animationend', () => toast.remove(), { once: true });
    }, duration);
}
function navigateTo(viewId) {
    $$('.view').forEach(v => v.classList.remove('active'));
    const target = $(`view-${viewId}`);
    if (!target) return;
    target.classList.add('active');
    window.scrollTo({ top: 0, behavior: 'instant' });
    const navMap = { product: 'home', checkout: 'cart' };
    const navKey = navMap[viewId] || viewId;
    $$('.nav-item').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.view === navKey);
    });
    switch (viewId) {
        case 'home':     renderHome(); break;
        case 'cart':     renderCart(); break;
        case 'checkout': renderCheckout(); break;
        case 'orders':   loadAndRenderOrders(); break;
    }
}
function fmtUSD(n) {
    return `$${Number(n).toFixed(2)}`;
}
function fmtBs(usd) {
    if (!State.tasaBcv) return '';
    const bs = usd * State.tasaBcv;
    return `Bs${bs.toLocaleString('es-VE', { minimumFractionDigits: 0, maximumFractionDigits: 0 })}`;
}
function formatCurrency(usd) {
    return State.monedaActiva === 'Bs' ? fmtBs(usd) : fmtUSD(usd);
}
function fmtDate(iso) {
    const d = new Date(iso);
    const months = ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
    return `${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear()}`;
}
function displayCat(dbCat) {
    if (State.idiomaActivo === 'en') return CATEGORY_DISPLAY_EN[dbCat] || CATEGORY_DISPLAY_EN[CATEGORY_DISPLAY[dbCat]] || dbCat;
    if (State.idiomaActivo === 'pt') return CATEGORY_DISPLAY_PT[dbCat] || CATEGORY_DISPLAY_PT[CATEGORY_DISPLAY[dbCat]] || dbCat;
    if (State.idiomaActivo === 'de') return CATEGORY_DISPLAY_DE[dbCat] || CATEGORY_DISPLAY_DE[CATEGORY_DISPLAY[dbCat]] || dbCat;
    return CATEGORY_DISPLAY[dbCat] || dbCat;
}
function translateName(originalName) {
    if (State.idiomaActivo !== 'es' && State.diccionarioTraducciones[originalName]) {
        return State.diccionarioTraducciones[originalName];
    }
    return originalName;
}
function updateStaticTranslations() {
    $$('[data-i18n]').forEach(el => {
        const key = el.dataset.i18n;
        if (I18N[State.idiomaActivo] && I18N[State.idiomaActivo][key]) {
            el.textContent = I18N[State.idiomaActivo][key];
        }
    });
    const searchInput = $('search-input');
    if (searchInput) {
        searchInput.placeholder = I18N[State.idiomaActivo]['search'];
    }
}
function dbCatFromDisplay(displayName) {
    for (const [db, disp] of Object.entries(CATEGORY_DISPLAY)) {
        if (disp === displayName) return db;
    }
    return displayName;
}
function updateCartBadge() {
    const total = State.carrito.reduce((s, i) => s + i.cantidad, 0);
    const badge = $('nav-cart-badge');
    if (total > 0) {
        badge.style.display = 'flex';
        badge.textContent = total > 99 ? '99+' : total;
    } else {
        badge.style.display = 'none';
    }
}
function cartQtyOf(productId) {
    const item = State.carrito.find(i => i.idProducto === productId);
    return item ? item.cantidad : 0;
}
function validateCart() {
    let changed = false;
    State.carrito = State.carrito.filter(item => {
        const p = State.productos[item.idProducto];
        if (!p || !p.disponible) { changed = true; return false; }
        if (item.cantidad > p.stock) {
            item.cantidad = p.stock;
            changed = true;
        }
        if (item.cantidad <= 0) { changed = true; return false; }
        if (item.precioUnitario !== p.precio) {
            item.precioUnitario = p.precio;
            changed = true;
        }
        return true;
    });
    if (changed) saveCart();
}
function renderHome() {
    const el = $('welcome-name');
    el.textContent = State.clienteNombre
        ? `${State.clienteNombre}!`
        : 'Welcome!';
    renderCategoryTabs();
    renderProductGrid();
}
function renderCategoryTabs() {
    const container = $('category-tabs');
    container.innerHTML = CATEGORY_ORDER.map(cat =>
        `<button class="category-tab${cat === State.categoriaActiva ? ' active' : ''}"
                 data-category="${cat}">${displayCat(cat).toUpperCase()}</button>`
    ).join('');
    container.addEventListener('click', (e) => {
        const tab = e.target.closest('.category-tab');
        if (!tab) return;
        State.categoriaActiva = tab.dataset.category;
        container.querySelectorAll('.category-tab').forEach(t =>
            t.classList.toggle('active', t.dataset.category === State.categoriaActiva)
        );
        renderProductGrid();
    });
}
function renderProductGrid() {
    const grid = $('product-grid');
    const search = ($('search-input')?.value || '').toLowerCase().trim();
    let items = Object.entries(State.productos)
        .filter(([, p]) => p.disponible);
    if (search) {
        items = items.filter(([, p]) =>
            p.nombre.toLowerCase().includes(search) ||
            p.descripcion.toLowerCase().includes(search) ||
            p.categoria.toLowerCase().includes(search)
        );
    }
    if (State.categoriaActiva !== 'Todos') {
        const dbCat = dbCatFromDisplay(State.categoriaActiva);
        items = items.filter(([, p]) => p.categoria === dbCat);
    }
    if (items.length === 0) {
        grid.innerHTML = `
            <div class="empty-state" style="grid-column:1/-1">
                <div class="empty-icon">🔍</div>
                <p>No se encontraron productos</p>
            </div>`;
        return;
    }
    if (State.categoriaActiva === 'Todos' && !search) {
        const groups = {};
        items.forEach(([id, p]) => {
            const dc = displayCat(p.categoria);
            (groups[dc] = groups[dc] || []).push([id, p]);
        });
        const sorted = Object.keys(groups).sort((a, b) => {
            const ia = CATEGORY_ORDER.indexOf(a), ib = CATEGORY_ORDER.indexOf(b);
            return (ia < 0 ? 999 : ia) - (ib < 0 ? 999 : ib);
        });
        let html = '', idx = 0;
        sorted.forEach(cat => {
            html += `<h2 class="category-section-title">${cat.toUpperCase()}</h2>`;
            groups[cat].forEach(([id, p]) => {
                html += productCardHTML(id, p, idx++);
            });
        });
        grid.innerHTML = html;
        grid.classList.remove('is-todos');
    } else {
        grid.innerHTML = items.map(([id, p], i) => productCardHTML(id, p, i)).join('');
        grid.classList.remove('is-todos');
    }
    grid.addEventListener('click', onProductCardClick);
}
function onProductCardClick(e) {
    const btnAdd = e.target.closest('.product-card-add-btn');
    if (btnAdd) {
        e.stopPropagation();
        const card = btnAdd.closest('.product-card');
        if (card) {
            // Quick add 1 unit to cart
            const productId = card.dataset.pid;
            const p = State.productos[productId];
            if (p && p.stock > 0) {
                const existing = State.carrito.find(i => i.idProducto === productId);
                if (existing) {
                    if (existing.cantidad < p.stock) {
                        existing.cantidad += 1;
                        showToast(`Añadido +1 ${translateName(p.nombre)}`, 'success');
                    } else {
                        showToast('No hay más stock disponible', 'warning');
                    }
                } else {
                    State.carrito.push({
                        idProducto: productId,
                        cantidad: 1,
                        precioUnitario: p.precio,
                        timestamp: Date.now()
                    });
                    showToast(`${translateName(p.nombre)} añadido`, 'success');
                }
                saveCart();
                updateCartBadge();
            }
        }
        return;
    }

    const card = e.target.closest('.product-card');
    if (!card) return;
    openProductDetail(card.dataset.pid);
}
const IMG_FALLBACK = `data:image/svg+xml,${encodeURIComponent(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">' +
    '<rect fill="#f0f4f7" width="200" height="200"/>' +
    '<text x="100" y="110" text-anchor="middle" font-family="sans-serif" font-size="48" fill="#ccd5dd">📦</text></svg>'
)}`;
function productCardHTML(id, p, index) {
    const delay = Math.min(index * 40, 350);
    // Extraemos la unidad de la descripción o si no, usamos el peso si existe. (Por ahora, ponemos 750g como placeholder si no sabemos)
    const weightMatch = p.descripcion.match(/(\d+\s*(?:g|kg|ml|l|oz))/i);
    const weightTag = weightMatch ? weightMatch[1].toUpperCase() : '750 G'; 
    const stockTag = p.stock > 0 ? (p.stock < 5 ? `¡Solo ${p.stock}!` : 'Stock') : 'Agotado';

    return `
    <div class="product-card" data-pid="${id}" style="animation-delay:${delay}ms">
        <div class="product-card-tags">
            <span class="card-tag weight">${weightTag}</span>
            <span class="card-tag stock">${stockTag}</span>
        </div>
        <img class="product-card-image" src="${p.url}" alt="${translateName(p.nombre)}"
             loading="lazy" onerror="this.onerror=null;this.src='${IMG_FALLBACK}'">
        <div class="product-card-info">
            <p class="product-card-name">${translateName(p.nombre)}</p>
            <div class="product-card-price">
                <span class="product-card-price-value">${formatCurrency(p.precio)}</span>
            </div>
        </div>
        <button class="product-card-add-btn" aria-label="Añadir al carrito">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        </button>
    </div>`;
}
function openProductDetail(productId) {
    const p = State.productos[productId];
    if (!p) return;
    State.productoSeleccionado = { id: productId, ...p };
    State.cantidadSeleccionada = 1;
    $('detail-product-name').textContent   = translateName(p.nombre).toUpperCase();
    $('detail-header-category').textContent = displayCat(p.categoria).toUpperCase();
    $('detail-image').src = p.url;
    $('detail-image').alt = p.nombre;
    $('detail-image').onerror = function() { this.onerror=null; this.src=IMG_FALLBACK; };
    $('detail-description').textContent    = p.descripcion;
    $('detail-category-pill').textContent   = displayCat(p.categoria);
    $('detail-price').textContent           = `$${p.precio}`;
    updateDetailStock();
    updateDetailQty();
    navigateTo('product');
}
function updateDetailStock() {
    const p = State.productoSeleccionado;
    if (!p) return;
    const inCart     = cartQtyOf(p.id);
    const available  = p.stock - inCart;
    const dot        = $('detail-stock-dot');
    const val        = $('detail-stock');
    const txt        = $('detail-stock-text');
    if (available <= 0) {
        dot.classList.add('out-of-stock');
        val.classList.add('out-of-stock');
        txt.textContent = 'Agotado';
    } else {
        dot.classList.remove('out-of-stock');
        val.classList.remove('out-of-stock');
        txt.textContent = `${available} unid.`;
    }
}
function updateDetailQty() {
    const p   = State.productoSeleccionado;
    if (!p) return;
    const qty       = State.cantidadSeleccionada;
    const inCart     = cartQtyOf(p.id);
    const maxQty     = Math.max(p.stock - inCart, 0);
    $('detail-qty').textContent = qty;
    if (maxQty <= 0) {
        $('detail-add-text').textContent = 'Sin stock';
        $('detail-add-btn').disabled = true;
    } else {
        $('detail-add-text').textContent = `Añadir - $${(p.precio * qty).toFixed(2)}`;
        $('detail-add-btn').disabled = false;
    }
    $('detail-qty-minus').disabled = qty <= 1;
    $('detail-qty-plus').disabled  = qty >= maxQty;
}
function addToCart(productId, quantity) {
    const p = State.productos[productId];
    if (!p) return;
    const existing = State.carrito.find(i => i.idProducto === productId);
    if (existing) {
        const newQty = existing.cantidad + quantity;
        if (newQty > p.stock) {
            showToast('No hay suficiente stock', 'warning');
            return;
        }
        existing.cantidad = newQty;
    } else {
        if (quantity > p.stock) {
            showToast('No hay suficiente stock', 'warning');
            return;
        }
        State.carrito.push({
            idProducto:     productId,
            nombre:         p.nombre,
            cantidad:       quantity,
            precioUnitario: p.precio,
            categoria:      p.categoria,
            url:            p.url,
        });
    }
    saveCart();
    updateCartBadge();
    showToast(`${p.nombre} añadido al carrito`, 'success');
}
function updateCartItem(productId, newQty) {
    const p = State.productos[productId];
    if (!p) return;
    if (newQty > p.stock) {
        showToast('Stock máximo alcanzado', 'warning');
        return;
    }
    if (newQty <= 0) { removeCartItem(productId); return; }
    const item = State.carrito.find(i => i.idProducto === productId);
    if (item) {
        item.cantidad = newQty;
        saveCart();
        updateCartBadge();
        renderCart();
    }
}
function removeCartItem(productId) {
    State.carrito = State.carrito.filter(i => i.idProducto !== productId);
    saveCart();
    updateCartBadge();
    renderCart();
    showToast('Producto eliminado', 'info');
}
function renderCart() {
    const list   = $('cart-items');
    const empty  = $('cart-empty');
    const footer = $('cart-footer');
    if (State.carrito.length === 0) {
        list.innerHTML = '';
        empty.classList.remove('hidden');
        footer.classList.add('hidden');
        return;
    }
    empty.classList.add('hidden');
    footer.classList.remove('hidden');
    list.innerHTML = State.carrito.map((item, i) => `
        <div class="cart-item" style="animation-delay:${i * 70}ms">
            <img class="cart-item-image" src="${item.url}" alt="${translateName(item.nombre)}"
                 onerror="this.onerror=null;this.src='${IMG_FALLBACK}'">
            <div class="cart-item-info">
                <p class="cart-item-name">${translateName(item.nombre)}</p>
                <p class="cart-item-category">${displayCat(item.categoria)}</p>
                <p class="cart-item-price">${formatCurrency(item.precioUnitario * item.cantidad)}</p>
            </div>
            <div class="cart-item-controls">
                <button class="cart-qty-btn" data-act="dec" data-id="${item.idProducto}">−</button>
                <span class="cart-qty-value">${item.cantidad}</span>
                <button class="cart-qty-btn" data-act="inc" data-id="${item.idProducto}">+</button>
            </div>
            <button class="cart-item-delete" data-act="del" data-id="${item.idProducto}" aria-label="Eliminar">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="3 6 5 6 21 6"/>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                </svg>
            </button>
        </div>
    `).join('');
    const total = State.carrito.reduce((s, i) => s + i.precioUnitario * i.cantidad, 0);
    $('cart-total').textContent = formatCurrency(total);
    
    // Sync toggle switch state
    const toggleCart = $('currency-toggle-cart');
    if (toggleCart) toggleCart.checked = State.monedaActiva === 'Bs';

    list.onclick = (e) => {
        const btn = e.target.closest('[data-act]');
        if (!btn) return;
        e.stopPropagation();
        const id   = btn.dataset.id;
        const act  = btn.dataset.act;
        const item = State.carrito.find(i => i.idProducto === id);
        if (!item) return;
        if (act === 'inc')      updateCartItem(id, item.cantidad + 1);
        else if (act === 'dec') updateCartItem(id, item.cantidad - 1);
        else if (act === 'del') removeCartItem(id);
    };
}
function renderCheckout() {
    if (State.carrito.length === 0) { navigateTo('cart'); return; }
    $('checkout-items').innerHTML = State.carrito.map(item => `
        <div class="checkout-item">
            <span class="checkout-item-name">${item.cantidad}× ${translateName(item.nombre)}</span>
            <span class="checkout-item-price">${formatCurrency(item.precioUnitario * item.cantidad)}</span>
        </div>
    `).join('');
    const total = State.carrito.reduce((s, i) => s + i.precioUnitario * i.cantidad, 0);
    $('checkout-total').textContent = formatCurrency(total);
    
    // Sync toggle switch state
    const toggleCheckout = $('currency-toggle-checkout');
    if (toggleCheckout) toggleCheckout.checked = State.monedaActiva === 'Bs';

    const input = $('checkout-name');
    if (State.clienteNombre && !input.value) {
        input.value = State.clienteNombre;
    }
    updateCreateBtn();
}
function updateCreateBtn() {
    const name = ($('checkout-name')?.value || '').trim();
    $('btn-create-order').disabled = name.length === 0;
}
async function createOrder() {
    const name = ($('checkout-name')?.value || '').trim();
    if (!name || State.carrito.length === 0) return;
    const btn = $('btn-create-order');
    btn.disabled = true;
    btn.innerHTML = '<span class="loading-spinner" style="width:20px;height:20px;border-width:2px"></span> Procesando...';
    try {
        const pedidos = await Firebase.get('pedidos');
        let lastNum = 1000;
        if (pedidos) {
            Object.keys(pedidos).forEach(key => {
                const m = key.match(/ped_(\d+)/);
                if (m) {
                    const n = parseInt(m[1], 10);
                    if (n > lastNum) lastNum = n;
                }
            });
        }
        const newNum = lastNum + 1;
        const newId  = `ped_${String(newNum).padStart(4, '0')}`;
        const codigo = `#${newNum}`;
        const totalUSD = State.carrito.reduce((s, i) => s + i.precioUnitario * i.cantidad, 0);
        const totalBs  = totalUSD * State.tasaBcv;
        const orderData = {
            articulos: State.carrito.map(item => ({
                cantidad:       item.cantidad,
                idProducto:     item.idProducto,
                nombre:         item.nombre,
                precioUnitario: item.precioUnitario,
                subtotal:       item.precioUnitario * item.cantidad,
            })),
            cliente:      name,
            codigoCorto:  codigo,
            estado:       'pendiente',
            fecha:        new Date().toISOString(),
            tasaUsada:    State.tasaBcv,
            totalBs:      parseFloat(totalBs.toFixed(2)),
            totalDivisas: parseFloat(totalUSD.toFixed(2)),
        };
        await Firebase.put(`pedidos/${newId}`, orderData);
        saveClientName(name);
        State.carrito = [];
        saveCart();
        updateCartBadge();
        $('order-success-code').textContent = `Código: ${codigo}`;
        $('order-success-modal').classList.remove('hidden');
    } catch (err) {
        console.error('Order creation error:', err);
        showToast('Error al crear el pedido. Intenta de nuevo.', 'error', 5000);
        btn.disabled = false;
        btn.innerHTML =
            '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>' +
            ' <span>CREAR PEDIDO</span>';
    }
}
async function loadAndRenderOrders() {
    const list  = $('orders-list');
    const empty = $('orders-empty');
    list.innerHTML = `
        <div class="empty-state">
            <div class="loading-spinner" style="border-top-color:var(--accent)"></div>
            <p>Cargando pedidos...</p>
        </div>`;
    empty.classList.add('hidden');
    try {
        const pedidos = await Firebase.get('pedidos');
        if (!pedidos || !State.clienteNombre) {
            list.innerHTML = '';
            empty.classList.remove('hidden');
            return;
        }
        const mine = Object.entries(pedidos)
            .filter(([, o]) => o.cliente.toLowerCase() === State.clienteNombre.toLowerCase())
            .sort((a, b) => new Date(b[1].fecha) - new Date(a[1].fecha));
        if (mine.length === 0) {
            list.innerHTML = '';
            empty.classList.remove('hidden');
            return;
        }
        empty.classList.add('hidden');
        list.innerHTML = mine.map(([, order], i) => `
            <div class="order-card" style="animation-delay:${i * 70}ms">
                <div class="order-header">
                    <span class="order-code">${order.codigoCorto}</span>
                    <span class="order-status ${order.estado}">${capitalize(order.estado)}</span>
                </div>
                <p class="order-meta">${order.cliente} · ${fmtDate(order.fecha)}</p>
                <div class="order-items">
                    ${(order.articulos || []).map(a => `
                        <div class="order-item-row">
                            <span>${a.cantidad}× ${a.nombre}</span>
                            <span>${fmtUSD(a.subtotal)}</span>
                        </div>
                    `).join('')}
                </div>
                <div class="order-total-row">
                    <span>Total</span>
                    <span>${fmtUSD(order.totalDivisas)}</span>
                </div>
            </div>
        `).join('');
    } catch (err) {
        console.error('Load orders error:', err);
        list.innerHTML = '';
        showToast('Error al cargar pedidos', 'error');
    }
}
function capitalize(s) {
    return s ? s.charAt(0).toUpperCase() + s.slice(1) : '';
}
function debounce(fn, ms) {
    let timer;
    return (...args) => { clearTimeout(timer); timer = setTimeout(() => fn(...args), ms); };
}
function setupEvents() {
    $$('.nav-item').forEach(btn => {
        btn.addEventListener('click', () => navigateTo(btn.dataset.view));
    });
    $('btn-back-detail')?.addEventListener('click',   () => navigateTo('home'));
    $('btn-back-cart')?.addEventListener('click',     () => navigateTo('home'));
    $('btn-back-checkout')?.addEventListener('click', () => navigateTo('cart'));
    $('btn-back-orders')?.addEventListener('click',   () => navigateTo('home'));
    $('search-input')?.addEventListener('input', debounce(renderProductGrid, 250));
    $('detail-qty-minus')?.addEventListener('click', () => {
        if (State.cantidadSeleccionada > 1) {
            State.cantidadSeleccionada--;
            updateDetailQty();
        }
    });
    $('detail-qty-plus')?.addEventListener('click', () => {
        const p = State.productoSeleccionado;
        if (!p) return;
        const max = p.stock - cartQtyOf(p.id);
        if (State.cantidadSeleccionada < max) {
            State.cantidadSeleccionada++;
            updateDetailQty();
        }
    });
    $('detail-add-btn')?.addEventListener('click', () => {
        if (!State.productoSeleccionado) return;
        addToCart(State.productoSeleccionado.id, State.cantidadSeleccionada);
        navigateTo('home');
    });
    $('btn-go-checkout')?.addEventListener('click', () => {
        if (State.carrito.length > 0) navigateTo('checkout');
    });
    $('btn-explore-catalog')?.addEventListener('click', () => navigateTo('home'));
    $('checkout-name')?.addEventListener('input', updateCreateBtn);
    $('btn-create-order')?.addEventListener('click', createOrder);
    $('btn-success-ok')?.addEventListener('click', () => {
        $('order-success-modal').classList.add('hidden');
        navigateTo('orders');
    });
    $('btn-refresh-orders')?.addEventListener('click', loadAndRenderOrders);
    
    // Currency Toggle Listeners
    $('currency-toggle-home')?.addEventListener('change', (e) => {
        State.monedaActiva = e.target.checked ? 'Bs' : 'USD';
        syncCurrencyToggles();
        renderHome();
    });
    $('currency-toggle-cart')?.addEventListener('change', (e) => {
        State.monedaActiva = e.target.checked ? 'Bs' : 'USD';
        syncCurrencyToggles();
        renderCart();
    });
    $('currency-toggle-checkout')?.addEventListener('change', (e) => {
        State.monedaActiva = e.target.checked ? 'Bs' : 'USD';
        syncCurrencyToggles();
        renderCheckout();
    });

    function syncCurrencyToggles() {
        const checked = State.monedaActiva === 'Bs';
        if ($('currency-toggle-home')) $('currency-toggle-home').checked = checked;
        if ($('currency-toggle-cart')) $('currency-toggle-cart').checked = checked;
        if ($('currency-toggle-checkout')) $('currency-toggle-checkout').checked = checked;
    }

    $('btn-start-shopping')?.addEventListener('click', () => navigateTo('home'));
    
    $('lang-current')?.addEventListener('click', (e) => {
        e.stopPropagation();
        $('lang-dropdown')?.classList.toggle('hidden');
    });
    $$('.lang-option').forEach(opt => {
        opt.addEventListener('click', () => {
            $('lang-dropdown')?.classList.add('hidden');
            changeLanguage(opt.dataset.lang);
        });
    });
    document.addEventListener('click', () => {
        $('lang-dropdown')?.classList.add('hidden');
    });
}
async function init() {
    try {
        loadCart();
        loadClientName();
        updateCartBadge();
        const [config, productos] = await Promise.all([
            Firebase.get('configuracion'),
            Firebase.get('productos'),
        ]);
        if (config) {
            State.tasaBcv       = config.tasaBcv || 0;
            State.tiendaAbierta = config.tiendaAbierta !== false;
            const bcvValEl = $('bcv-val');
            if (bcvValEl && State.tasaBcv) {
                bcvValEl.textContent = `Bs ${State.tasaBcv.toLocaleString('es-VE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
            }
        }
        if (productos) {
            State.productos = productos;
        }
        validateCart();
        updateCartBadge();
        if (!State.tiendaAbierta) {
            $('store-closed-overlay').classList.remove('hidden');
        }
        setupEvents();
        renderHome();
        $('loading-screen').classList.add('hidden');
        $('app').classList.remove('hidden');
    } catch (err) {
        console.error('Init failed:', err);
        $('loading-screen').innerHTML = `
            <div style="text-align:center;color:white;padding:2rem">
                <div style="font-size:2.5rem;margin-bottom:1rem">⚠️</div>
                <h2 style="font-weight:700;margin-bottom:0.5rem">Error de Conexión</h2>
                <p style="opacity:0.6;margin-bottom:1.5rem;font-size:0.9rem">No se pudo conectar con el servidor.</p>
                <button onclick="location.reload()" style="
                    background:rgba(255,255,255,0.12);color:white;
                    padding:13px 28px;border-radius:16px;border:none;
                    cursor:pointer;font-size:0.88rem;font-weight:600;
                    font-family:inherit;transition:background 0.2s">
                    Reintentar
                </button>
            </div>`;
    }
}
document.addEventListener('DOMContentLoaded', init);

// --- Traducción MyMemory ---
const MYMEMORY_EMAIL = 'rrodrguez.0788@unimar.edu.ve';
async function fetchTranslation(text, targetLang) {
    try {
        const url = `https://api.mymemory.translated.net/get?q=${encodeURIComponent(text)}&langpair=es|${targetLang}&de=${MYMEMORY_EMAIL}`;
        const res = await fetch(url);
        const data = await res.json();
        return data.responseData.translatedText;
    } catch (e) {
        console.error('Translation error:', e);
        return text;
    }
}

const LANG_EMOJIS = { es: '🇪🇸 ES', en: '🇺🇸 EN', pt: '🇵🇹 PT', de: '🇩🇪 DE' };

async function changeLanguage(lang) {
    if (State.idiomaActivo === lang) return;
    
    if (lang !== 'es') {
        const cached = localStorage.getItem(`catalogo_${lang}`);
        if (cached) {
            State.diccionarioTraducciones = JSON.parse(cached);
        } else {
            const loading = $('loading-screen');
            if (loading) {
                loading.querySelector('p').textContent = 'Traduciendo catálogo, un momento...';
                loading.classList.remove('hidden');
            }
            
            State.diccionarioTraducciones = {};
            const namesToTranslate = new Set();
            Object.values(State.productos).forEach(p => namesToTranslate.add(p.nombre));
            
            const arr = Array.from(namesToTranslate);
            for (let i = 0; i < arr.length; i++) {
                const esText = arr[i];
                State.diccionarioTraducciones[esText] = await fetchTranslation(esText, lang);
                await new Promise(r => setTimeout(r, 150));
            }
            localStorage.setItem(`catalogo_${lang}`, JSON.stringify(State.diccionarioTraducciones));
            
            if (loading) loading.classList.add('hidden');
        }
    } else {
        State.diccionarioTraducciones = {};
    }
    
    State.idiomaActivo = lang;
    
    const textEl = $('lang-current-text');
    if (textEl) textEl.textContent = LANG_EMOJIS[lang] || '🇪🇸 ES';
    
    $$('.lang-option').forEach(el => el.classList.toggle('active', el.dataset.lang === lang));
    
    updateStaticTranslations();
    renderCategoryTabs();
    if ($('view-home').classList.contains('active')) renderProductGrid();
    else if ($('view-cart').classList.contains('active')) renderCart();
    else if ($('view-checkout').classList.contains('active')) renderCheckout();
}
