# 📚 GitHub Wiki Content

This directory contains the content for the GitHub wiki.

## 🚀 Setting Up the Wiki

### Option 1: GitHub Web Interface (Easiest)

1. **Enable Wiki:**
   - Go to your repo: https://github.com/SmartMur/homelab
   - Settings → Features → Check "Wikis"

2. **Create First Page:**
   - Click "Wiki" tab
   - Click "Create the first page"
   - Title: "Home"
   - Copy content from `wiki/Home.md`
   - Save

3. **Add More Pages:**
   - Click "New Page"
   - Title: "Getting Started" (matches filename without .md)
   - Copy content from `wiki/Getting-Started.md`
   - Save
   - Repeat for other pages

### Option 2: Clone Wiki Repository (Advanced)

GitHub wikis are Git repositories:

```bash
# Clone wiki repo
git clone https://github.com/SmartMur/homelab.wiki.git

# Copy wiki files
cp wiki/*.md homelab.wiki/

# Commit and push
cd homelab.wiki
git add .
git commit -m "Add wiki content"
git push
```

## 📁 Wiki Files Structure

Current wiki pages:

```
wiki/
├── README.md           # This file (setup instructions)
├── Home.md            # Wiki homepage
└── Getting-Started.md # Getting started guide
```

### Pages to Create (Coming Soon)

You can create these pages as you expand the wiki:

**Getting Started Section:**
- Hardware-Guide.md
- Docker-Basics.md
- First-30-Days.md
- Common-Mistakes.md

**Service Guides:**
- Traefik-Setup.md
- Pihole-Setup.md
- Authelia-Setup.md
- Vaultwarden-Setup.md
- Jellyfin-Setup.md
- Nextcloud-Setup.md
- (Create one for each service)

**Advanced Topics:**
- Kubernetes-Deployment.md
- High-Availability.md
- Monitoring-Stack.md
- Security-Hardening.md
- Backup-Strategy.md

**Reference:**
- Service-Catalog.md
- Troubleshooting.md
- Best-Practices.md
- Glossary.md

## ✍️ Writing Wiki Pages

### Page Naming Convention

- **Filename:** `Page-Name.md` (kebab-case with .md extension)
- **Wiki Title:** "Page Name" (spaces, no .md)
- **Links:** `[Link Text](Page-Name)` (no .md in links!)

**Examples:**
```markdown
Filename: Getting-Started.md
Title: Getting Started
Link: [Getting Started](Getting-Started)

Filename: Docker-Basics.md
Title: Docker Basics
Link: [Docker Basics](Docker-Basics)
```

### Markdown Tips

GitHub wikis support standard Markdown:

```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*
`code`

[Link](Page-Name)
![Image](url)

- Bullet list
1. Numbered list

> Quote

\`\`\`bash
code block
\`\`\`
```

### Internal Links

Link to other wiki pages:
```markdown
See the [Getting Started](Getting-Started) guide.
Read about [Docker Basics](Docker-Basics).
```

Link to main repo files:
```markdown
See [README.md](https://github.com/SmartMur/homelab/blob/main/README.md)
Check [Traefik config](https://github.com/SmartMur/homelab/tree/main/Traefikv3)
```

## 🎨 Wiki Sidebar (Optional)

Create `_Sidebar.md` for custom sidebar:

```markdown
## 🏠 [Home](Home)

### Getting Started
- [Getting Started](Getting-Started)
- [Hardware Guide](Hardware-Guide)
- [Docker Basics](Docker-Basics)

### Services
- [Traefik](Traefik-Setup)
- [Pi-hole](Pihole-Setup)
- [Authelia](Authelia-Setup)

### Advanced
- [Kubernetes](Kubernetes-Deployment)
- [Monitoring](Monitoring-Stack)
- [Backups](Backup-Strategy)

### Reference
- [Service Catalog](Service-Catalog)
- [Troubleshooting](Troubleshooting)
- [Glossary](Glossary)
```

## 🔄 Updating the Wiki

### From Web Interface
1. Go to wiki page
2. Click "Edit"
3. Make changes
4. Save with commit message

### From Git
```bash
cd homelab.wiki
# Edit files
git add .
git commit -m "Update documentation"
git push
```

### Syncing with Main Repo

Keep `wiki/` folder in main repo synced with actual wiki:

```bash
# In main repo
cp ../homelab.wiki/*.md wiki/
git add wiki/
git commit -m "Sync wiki content"
git push
```

## 📊 Wiki Organization Best Practices

### Page Structure

Every page should have:
1. **Title** - Clear, descriptive
2. **Introduction** - What is this page about?
3. **Table of Contents** - For long pages
4. **Content** - Well-organized sections
5. **Related Links** - Link to related pages
6. **Next Steps** - Where to go next

### Example Template

```markdown
# Page Title

> Brief description of what this page covers

## 📖 Table of Contents
- [Section 1](#section-1)
- [Section 2](#section-2)

## Section 1
Content here...

## Section 2
Content here...

## Related Pages
- [Related Page 1](Page-1)
- [Related Page 2](Page-2)

## Next Steps
- [ ] Do this
- [ ] Then this
```

## 🎯 Priority Pages to Create

Start with these high-impact pages:

**High Priority (Week 1):**
1. ✅ Home.md - Done!
2. ✅ Getting-Started.md - Done!
3. Service-Catalog.md - List all 90+ services
4. Troubleshooting.md - Common issues
5. Docker-Basics.md - Docker fundamentals

**Medium Priority (Week 2):**
6. Hardware-Guide.md - Buying recommendations
7. Traefik-Setup.md - First service guide
8. Pihole-Setup.md - DNS & ad blocking
9. Authelia-Setup.md - Security setup
10. Backup-Strategy.md - Critical for data safety

**Lower Priority (Ongoing):**
- Individual service guides (create as needed)
- Advanced topics (Kubernetes, HA, etc.)
- Reference materials (glossary, best practices)

## 📝 Contributing to Wiki

Anyone can suggest wiki improvements:

1. **Minor edits:**
   - Edit page directly (if you have access)
   - Or suggest via GitHub issue

2. **New pages:**
   - Create .md file in `wiki/` folder
   - Submit pull request to main repo
   - Maintainer will add to actual wiki

3. **Major changes:**
   - Open GitHub issue first
   - Discuss with community
   - Then implement

## 🔍 Wiki SEO Tips

Make wiki pages discoverable:

1. **Use clear titles** - Match search terms
2. **Add descriptions** - First paragraph is indexed
3. **Internal linking** - Link related pages
4. **Keywords** - Use terms people search for
5. **Examples** - Include working code/configs

## ✅ Wiki Checklist

Before publishing a new page:

- [ ] Title is clear and descriptive
- [ ] Introduction explains page purpose
- [ ] Content is well-organized with headers
- [ ] Code examples are tested and working
- [ ] Internal links work (no broken links)
- [ ] Images load properly (if any)
- [ ] Related pages are linked
- [ ] Spelling/grammar checked
- [ ] Consistent formatting

## 📚 Additional Resources

- [GitHub Wiki Guide](https://docs.github.com/en/communities/documenting-your-project-with-wikis)
- [Markdown Guide](https://www.markdownguide.org/)
- [Writing Good Documentation](https://www.writethedocs.org/guide/)

---

**Ready to set up the wiki?**  
Follow Option 1 above to get started! 🚀
