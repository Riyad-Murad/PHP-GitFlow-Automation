# PHP-GitFlow-Automation

## Git Workflow

### 1. Finish Feature on branch: Feature/JIRA-123-login-audit
```bash
git checkout Feature/JIRA-123-login-audit
# make code changes
git add .
git commit -m "JIRA-123 Add login audit logging"
git push origin Feature/JIRA-123-login-audit
```

### 2. Open Pull Request from GitHub
- **Base branch**: Develop
- **Title**: JIRA-123 Login audit
- **Description**: Implements login audit trail. Fixes JIRA-123

### 3. Finish Bugfix on branch: Bugfix/JIRA-456-session-fix
- Same as the comments from point 2 with PR containing "Fixes JIRA-456"

### 4. Release Flow: Create Temporary Release Branch
```bash
git checkout Develop
git pull origin Develop
git checkout -b Release/v1.0.0
git push origin Release/v1.0.0
```
**Purpose of Release/v1.0.0**:
- Final testing
- Small fixes only
- NO new features

### 5. Fix Issues Found During Release
```bash
git checkout Release/v1.0.0
# fix bug
git add .
git commit -m "Fix minor validation issue"
git push origin Release/v1.0.0
```

### 6. Merge Release into Production
1. Open PR:
   - **From**: Release/v1.0.0
   - **To**: Production
   - **Description**: Release v1.0.0

2. Merge using Merge Commit

3. Tag the release:
```bash
git checkout Production
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 7. Merge Release Back into Develop
```bash
git checkout Develop
git merge Release/v1.0.0
git push origin Develop
```
Then delete release branch:
```bash
git branch -d Release/v1.0.0
git push origin --delete Release/v1.0.0
```

### 8. Create Hotfix Branch From Production Branch
```bash
git checkout Production
git pull origin Production
git checkout -b Hotfix/JIRA-789-critical-patch
# apply fix
git add .
git commit -m "JIRA-789 Fix critical production issue"
git push origin Hotfix/JIRA-789-critical-patch
```

### 9. Merge Hotfix into Production
- PR:
  - **From**: Hotfix/JIRA-789-critical-patch
  - **To**: Production
  - **Description**: Fixes JIRA-789

### 10. Merge Hotfix Everywhere Else
- Merge into Develop
```bash
git checkout Develop
git merge Hotfix/JIRA-789-critical-patch
git push origin Develop
```
- If Release branch exists
```bash
git checkout Release/v1.0.0
git merge Hotfix/JIRA-789-critical-patch
git push origin Release/v1.0.0
```

## Deployment of Laravel App

To deploy the Laravel application on the server, follow these steps:

### Prerequisites
- Docker installed on the server
- Docker Compose installed on the server

### Deployment Steps

1. **Run Docker Compose**:
   ```bash
   docker compose up -d
   ```

2. **Verify containers are running**:
   ```bash
   docker compose ps
   ```

The application will automatically start and be accessible through the configured ports in `docker-compose.yaml`.

### Running the Application

The application automatically starts when running:
```bash
docker-compose up -d
```

It will be accessible through the configured ports in `docker-compose.yaml`.

### Continuous Deployment Workflow

When deploying through the Git workflow:

1. **Feature/Bugfix merged to Develop**: Deploy to staging environment
2. **Release branch created**: Prepare production environment
3. **Release merged to Production**: Deploy to production
4. **Tag created**: Keep track of production releases
5. **Hotfix deployed**: Apply emergency fixes to production and sync back to other branches

### Monitoring and Maintenance

- Check application logs: `docker-compose logs app`
- Check Nginx/Web server logs: `docker-compose logs web`
- Monitor container status: `docker-compose ps`
- View container resource usage: `docker stats`
- Set up automated backups for database volumes
