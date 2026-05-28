import 'package:flutter/material.dart';

enum MemberStatus { active, pending }
enum MemberRole { creator, member }
enum VoteChoice { yes, no }

class GroupMember {
  final int id;
  final String name;
  final String phone;
  final String initials;
  final MemberRole role;
  final MemberStatus status;
  final String? joinedAt;
  final Color color;

  const GroupMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.initials,
    required this.role,
    required this.status,
    required this.color,
    this.joinedAt,
  });

  bool get isCreator => role == MemberRole.creator;
  bool get isPending => status == MemberStatus.pending;

  GroupMember copyWith({MemberStatus? status, String? joinedAt}) => GroupMember(
    id: id, name: name, phone: phone, initials: initials,
    role: role, status: status ?? this.status,
    color: color, joinedAt: joinedAt ?? this.joinedAt,
  );
}

class GroupInvitation {
  final int id;
  final String fromName;
  final String fromPhone;
  final String fromInitials;
  final Color fromColor;
  final String groupName;
  final String groupEmoji;
  final int goal;
  final int memberCount;
  final int lockMonths;
  final String invitedAt;

  const GroupInvitation({
    required this.id,
    required this.fromName,
    required this.fromPhone,
    required this.fromInitials,
    required this.fromColor,
    required this.groupName,
    required this.groupEmoji,
    required this.goal,
    required this.memberCount,
    required this.lockMonths,
    required this.invitedAt,
  });
}

class WithdrawApproval {
  final int memberId;
  final String name;
  final String initials;
  final Color color;
  final VoteChoice? vote;

  const WithdrawApproval({
    required this.memberId,
    required this.name,
    required this.initials,
    required this.color,
    this.vote,
  });

  WithdrawApproval withVote(VoteChoice v) => WithdrawApproval(
    memberId: memberId, name: name, initials: initials, color: color, vote: v,
  );
}

class WithdrawRequest {
  final int id;
  final int walletId;
  final int requestedById;
  final String requestedBy;
  final String requestedAt;
  final int amount;
  final String reason;
  final String status;
  final List<WithdrawApproval> approvals;

  const WithdrawRequest({
    required this.id,
    required this.walletId,
    required this.requestedById,
    required this.requestedBy,
    required this.requestedAt,
    required this.amount,
    required this.reason,
    required this.status,
    required this.approvals,
  });

  ConsensusResult get consensus {
    final total = approvals.length;
    final yes = approvals.where((a) => a.vote == VoteChoice.yes).length;
    final no = approvals.where((a) => a.vote == VoteChoice.no).length;
    final required = (total * 0.8).ceil();
    final pct = required > 0 ? (yes / required).clamp(0.0, 1.0) : 0.0;
    return ConsensusResult(
      total: total, yes: yes, no: no, required: required,
      pct: pct, passed: yes >= required, failed: no > total - required,
    );
  }

  WithdrawRequest copyWith({List<WithdrawApproval>? approvals, String? status}) => WithdrawRequest(
    id: id, walletId: walletId, requestedById: requestedById,
    requestedBy: requestedBy, requestedAt: requestedAt,
    amount: amount, reason: reason,
    status: status ?? this.status,
    approvals: approvals ?? this.approvals,
  );
}

class ConsensusResult {
  final int total;
  final int yes;
  final int no;
  final int required;
  final double pct;
  final bool passed;
  final bool failed;

  const ConsensusResult({
    required this.total, required this.yes, required this.no,
    required this.required, required this.pct,
    required this.passed, required this.failed,
  });
}
