function yeniSatirEkle() {
    const productList = document.getElementById('product-list');
    const newRow = productList.firstChild.cloneNode(true);
    newRow.querySelectorAll('input, textarea').forEach(el => el.value = '');
    productList.appendChild(newRow);
}

function kaydetUrun(button) {
    alert("Ürün Kaydedildi");
}

function duzeltUrun(button) {
    alert("Ürün Düzeltiliyor");
}

function kaydetMusteri() {
    alert("Müşteri Kaydedildi");
}

// Sütun yeniden boyutlandırma
const ths = document.querySelectorAll('th');
let isResizing = false;
let currentTH = null;
let startX = 0;
let startWidth = 0;
let nextTH = null;
let nextStartWidth = 0;

ths.forEach(th => {
    const resizer = document.createElement('div');
    resizer.classList.add('resizer');
    th.appendChild(resizer);

    resizer.addEventListener('mousedown', (e) => {
        isResizing = true;
        currentTH = th;
        startX = e.clientX;
        startWidth = th.offsetWidth;

        nextTH = th.nextElementSibling; // Bir sonraki th elementini al
        if (nextTH) {
            nextStartWidth = nextTH.offsetWidth;
        }
    });
});

document.addEventListener('mousemove', (e) => {
    if (!isResizing) return;

    const diffX = e.clientX - startX;

    const newWidth = startWidth + diffX;
    if (newWidth > 0) {
        currentTH.style.width = newWidth + 'px';

        if (nextTH) {
            const nextNewWidth = nextStartWidth - diffX;
            if (nextNewWidth > 0) {
                nextTH.style.width = nextNewWidth + 'px';

                 //Tablodaki hücrelerin genişliğini de güncelle
                const table = currentTH.closest('table');
                const colIndex = currentTH.cellIndex;
                const nextColIndex = nextTH.cellIndex;

                table.querySelectorAll('tr').forEach(row => {
                    row.cells[colIndex].style.width = newWidth + 'px';
                    row.cells[nextColIndex].style.width = nextNewWidth + 'px';
                });
            }
        }
    }

});

document.addEventListener('mouseup', () => {
    isResizing = false;
    currentTH = null;
    nextTH = null;
});
document.addEventListener('DOMContentLoaded', function() {
    yeniSatirEkle();
});
function yeniSatirEkle(){
    const tableBody = document.querySelector('#product-table tbody');
    const newRow = tableBody.rows[0].cloneNode(true);
    newRow.querySelectorAll('input, textarea').forEach(el => el.value = '');
    tableBody.appendChild(newRow);
}