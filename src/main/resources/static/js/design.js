/******************************* createreview  ***********************************/
document.addEventListener('DOMContentLoaded', function() {
    const textarea = document.getElementById('reviewContent');
    const charCount = document.getElementById('charCount');

    if (textarea) {
        textarea.addEventListener('input', function() {
            const count = this.value.length;
            charCount.textContent = count;
        });
    }
});