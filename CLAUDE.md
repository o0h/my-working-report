# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal blog/journal website called "まいにち書くぞ" (Daily Writing) built with Hugo static site generator. The site serves as a daily work report and personal reflection journal, written primarily in Japanese and hosted at `mainichi.nichiyoubi.land`.

## Essential Commands

### Build and Development
```bash
# Build the site
hugo

# Run local development server
hugo server -D

# Create new daily post (using date-based naming convention)
hugo new posts/$(date +%Y%m%d).md

# Auto-commit changes to repository
./scripts/auto-commit.sh
```

### Deployment
The site uses CircleCI for automated deployment to GitHub Pages. The deployment pipeline:
1. Commits to main branch trigger CircleCI
2. CircleCI builds the site using Hugo in Docker container
3. Built site is deployed to gh-pages branch
4. Custom domain serves content at mainichi.nichiyoubi.land

## Architecture and Structure

### Content Organization
- **Daily Posts**: `/content/posts/YYYYMMDD.md` - Daily entries with structured sections
- **Static Pages**: `/content/` - About and archives pages
- **Images**: `/static/images/posts/YYYY/MM/DD/` - Organized by date hierarchy

### Post Template Structure
Each daily post follows a specific template defined in `/archetypes/default.md`:
- よもやま (Miscellaneous thoughts)
- 気になった記事・読んだ記事など (Interesting articles/readings)
- 買った本・予約した本 (Books purchased/reserved)
- 便利ツール・ショートカット (Useful tools/shortcuts)
- 公開したもの (Published content)
- ひとこと (Final thoughts)

### Configuration
- **Main Config**: `config.toml` - Hugo settings, theme, navigation
- **CI/CD**: `circle.yml` - CircleCI deployment configuration
- **Theme**: Uses "one" theme in `/themes/one/` - minimalistic, mobile-ready design

## Development Notes

When working with this repository:
- Maintain the date-based naming convention for posts (YYYYMMDD.md)
- Place images in the correct date-based directory structure
- Content is in Japanese - preserve language and formatting conventions
- The auto-commit script handles standardized commit messages for daily posts