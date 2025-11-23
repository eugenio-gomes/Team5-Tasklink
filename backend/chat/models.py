from django.db import models
from users.models import User
from projects.models import Project


class Message(models.Model):
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, related_name="messages")
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="messages")
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.name}: {self.content[:30]}"
