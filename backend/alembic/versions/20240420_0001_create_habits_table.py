"""create habits table

Revision ID: 20240420_0001
Revises: 
Create Date: 2024-04-20 00:00:00.000000
"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy import inspect


# revision identifiers, used by Alembic.
revision = "20240420_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    bind = op.get_bind()
    inspector = inspect(bind)

    if "habits" not in inspector.get_table_names():
        op.create_table(
            "habits",
            sa.Column("id", sa.Integer(), primary_key=True),
            sa.Column("name", sa.Text(), nullable=False),
            sa.Column("description", sa.Text(), nullable=True),
            sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
            sa.Column("completed_today", sa.Boolean(), nullable=False, server_default=sa.false()),
        )
        op.create_index("ix_habits_id", "habits", ["id"], unique=False)


def downgrade() -> None:
    bind = op.get_bind()
    inspector = inspect(bind)

    if "habits" in inspector.get_table_names():
        op.drop_index("ix_habits_id", table_name="habits")
        op.drop_table("habits")
