/* ===================================
   FILE: script.js
   Beauty with USA - JavaScript
   =================================== */

document.documentElement.classList.add('js');

document.addEventListener('DOMContentLoaded', function() {

    // ===== MOBILE MENU TOGGLE =====
    const menuToggle = document.getElementById('menuToggle');
    const navMenu = document.getElementById('navMenu');
    const navLinks = document.querySelectorAll('.nav-link');

    function setMenuOpen(open) {
        navMenu.classList.toggle('active', open);
        menuToggle.classList.toggle('active', open);
        menuToggle.setAttribute('aria-expanded', String(open));
    }

    menuToggle.addEventListener('click', function() {
        setMenuOpen(!navMenu.classList.contains('active'));
    });

    // Close mobile menu when a link is clicked (smooth scroll + nav offset handled by CSS)
    navLinks.forEach(link => {
        link.addEventListener('click', () => setMenuOpen(false));
    });

    // Close menu when clicking outside or pressing Escape
    document.addEventListener('click', function(event) {
        const inside = navMenu.contains(event.target) || menuToggle.contains(event.target);
        if (!inside && navMenu.classList.contains('active')) setMenuOpen(false);
    });

    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && navMenu.classList.contains('active')) {
            setMenuOpen(false);
            menuToggle.focus();
        }
    });


    // ===== NAVBAR SHADOW ONCE HERO SCROLLS AWAY =====
    const navbar = document.getElementById('navbar');
    const hero = document.querySelector('.hero');

    if (hero) {
        new IntersectionObserver(([entry]) => {
            navbar.classList.toggle('scrolled', entry.intersectionRatio < 0.9);
        }, { threshold: [0.9] }).observe(hero);
    }


    // ===== HIGHLIGHT ACTIVE SECTION IN NAVIGATION =====
    const sectionObserver = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            navLinks.forEach(link => {
                link.classList.toggle('active', link.getAttribute('href') === '#' + entry.target.id);
            });
        });
    }, { rootMargin: '-45% 0px -50% 0px' });

    document.querySelectorAll('.section[id]').forEach(section => sectionObserver.observe(section));


    // ===== CONTACT FORM VALIDATION & SUBMISSION =====
    const contactForm = document.getElementById('contactForm');

    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();

        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const message = document.getElementById('message').value.trim();

        if (!name || !email || !phone || !message) {
            alert('Please fill in all required fields.');
            return;
        }

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert('Please enter a valid email address.');
            return;
        }

        const phonePattern = /^[\d\s\+\-\(\)]+$/;
        if (!phonePattern.test(phone)) {
            alert('Please enter a valid phone number.');
            return;
        }

        alert('Thank you for your message! We will get back to you soon.');
        contactForm.reset();

        // Note: In production, send this data to a server, e.g.
        // fetch('/api/contact', { method: 'POST', headers: { 'Content-Type': 'application/json' },
        //     body: JSON.stringify({ name, email, phone, business, message }) });
    });


    // ===== SCROLL REVEAL (CSS skips it under prefers-reduced-motion) =====
    const revealObserver = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                obs.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12, rootMargin: '0px 0px -60px 0px' });

    const revealGroups = ['.product-card', '.step-card', '.office-box', '.about-image', '.contact-form-container'];
    revealGroups.forEach(selector => {
        document.querySelectorAll(selector).forEach((el, i) => {
            el.classList.add('reveal');
            el.style.setProperty('--i', i % 4); // stagger within each row
            revealObserver.observe(el);
        });
    });


    console.log('Beauty with USA - Website Loaded Successfully');
    console.log('For inquiries: 071 369 4788 (Sri Lanka) | +1 302 802 3220 (USA)');
});
